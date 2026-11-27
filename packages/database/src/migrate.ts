import { Pool } from 'pg';
import * as fs from 'fs';
import * as path from 'path';
import * as dotenv from 'dotenv';

dotenv.config();

/**
 * Creates a PostgreSQL connection pool dynamically without hardcoded credential fallbacks.
 * Prioritizes DATABASE_URL if provided, otherwise uses standard PG environment variables.
 */
export function createDatabasePool(): Pool {
  if (process.env.DATABASE_URL) {
    return new Pool({ connectionString: process.env.DATABASE_URL });
  }

  return new Pool({
    host: process.env.PGHOST || process.env.PG_HOST || 'localhost',
    port: parseInt(process.env.PGPORT || process.env.PG_PORT || '5432', 10),
    database: process.env.PGDATABASE || process.env.PG_DATABASE || 'visulate',
    user: process.env.PGUSER || process.env.PG_USER,
    password: process.env.PGPASSWORD || process.env.PG_PASSWORD,
  });
}

export async function runMigrations(targetDir?: string): Promise<string[]> {
  const pool = createDatabasePool();
  const client = await pool.connect();
  const applied: string[] = [];

  try {
    await client.query('BEGIN');

    // Create migrations ledger table if not exists
    await client.query(`
      CREATE TABLE IF NOT EXISTS schema_migrations (\n        version VARCHAR(255) PRIMARY KEY,\n        applied_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp()\n      );
    `);

    const { rows: existingRows } = await client.query<{ version: string }>(
      'SELECT version FROM schema_migrations'
    );
    const existingVersions = new Set(existingRows.map(r => r.version));

    const migrationsDir = targetDir || path.resolve(__dirname, '../migrations');
    const files = fs.readdirSync(migrationsDir)
      .filter(f => f.endsWith('.sql'))
      .sort();

    for (const file of files) {
      if (existingVersions.has(file)) {
        console.log(`[migrate] Skipping already applied migration: ${file}`);
        continue;
      }

      console.log(`[migrate] Applying migration: ${file}`);
      const sql = fs.readFileSync(path.join(migrationsDir, file), 'utf-8');
      await client.query(sql);

      await client.query(
        'INSERT INTO schema_migrations (version) VALUES ($1)',
        [file]
      );
      applied.push(file);
      console.log(`[migrate] Successfully applied: ${file}`);
    }

    await client.query('COMMIT');
    console.log(`[migrate] Complete. ${applied.length} new migration(s) applied.`);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('[migrate] Migration failed, transaction rolled back:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }

  return applied;
}

if (require.main === module) {
  runMigrations().catch(err => {
    console.error(err);
    process.exit(1);
  });
}
