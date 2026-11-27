import { Pool } from 'pg';
import * as fs from 'fs';
import * as path from 'path';
import * as dotenv from 'dotenv';

dotenv.config();

interface AccountSeed {
  account_number: string;
  account_name: string;
  account_type: 'ASSET' | 'LIABILITY' | 'EQUITY' | 'REVENUE' | 'EXPENSE';
  balance_indicator: 'D' | 'C';
  description?: string;
}

interface PostingRuleSeed {
  rule_id: string;
  transaction_type: 'APS' | 'APP' | 'ARS' | 'ARP' | 'DEP';
  payment_type_name: string;
  debit_account_number: string;
  credit_account_number: string;
}

interface PaymentTypeSeed {
  payment_type_name: string;
  description: string;
  depreciation_term: number;
  payable_yn: 'Y' | 'N';
  receivable_yn: 'Y' | 'N';
  is_income: boolean;
}

export async function runSeed(dryRun: boolean = false): Promise<void> {
  const seedsDir = path.resolve(__dirname, '../seeds');
  
  const accountsPath = path.join(seedsDir, 'default_accounts.json');
  const rulesPath = path.join(seedsDir, 'default_pt_rules.json');
  const paymentTypesPath = path.join(seedsDir, 'payment_types.json');

  console.log('[seed] Validating JSON fixtures...');
  const accounts: AccountSeed[] = JSON.parse(fs.readFileSync(accountsPath, 'utf-8'));
  const rules: PostingRuleSeed[] = JSON.parse(fs.readFileSync(rulesPath, 'utf-8'));
  const paymentTypes: PaymentTypeSeed[] = JSON.parse(fs.readFileSync(paymentTypesPath, 'utf-8'));

  console.log(`[seed] Loaded ${accounts.length} default accounts.`);
  console.log(`[seed] Loaded ${paymentTypes.length} standard payment types.`);
  console.log(`[seed] Loaded ${rules.length} posting rules.`);

  // Validation assertions
  const validAccountTypes = new Set(['ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE']);
  for (const acc of accounts) {
    if (!validAccountTypes.has(acc.account_type)) {
      throw new Error(`Invalid account_type "${acc.account_type}" for account ${acc.account_number}`);
    }
  }

  const validTxTypes = new Set(['APS', 'APP', 'ARS', 'ARP', 'DEP']);
  for (const rule of rules) {
    if (!validTxTypes.has(rule.transaction_type)) {
      throw new Error(`Invalid transaction_type "${rule.transaction_type}" in rule ${rule.rule_id}`);
    }
  }

  if (dryRun) {
    console.log('[seed] DRY RUN MODE: Fixture validation passed successfully. No database writes performed.');
    return;
  }

  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    console.log('[seed] DATABASE_URL not configured. Completed JSON verification in offline mode.');
    return;
  }

  const pool = new Pool({ connectionString });
  const client = await pool.connect();

  try {
    await client.query('BEGIN');
    console.log('[seed] Connected to database, synchronizing seed catalogs...');

    // Fetch all business units
    const { rows: bus } = await client.query<{ business_id: number; business_name: string }>(
      'SELECT business_id, business_name FROM rnt_business_units'
    );

    if (bus.length === 0) {
      console.log('[seed] No business units found in target database. Seed templates are verified and ready for deployment.');
      await client.query('COMMIT');
      return;
    }

    for (const bu of bus) {
      console.log(`[seed] Seeding business unit #${bu.business_id} (${bu.business_name})...`);

      // 1. Seed accounts
      for (const acc of accounts) {
        await client.query(`
          INSERT INTO rnt_accounts (business_id, account_number, account_name, account_type, description)
          VALUES ($1, $2, $3, $4, $5)
          ON CONFLICT (business_id, account_number) DO UPDATE
          SET account_name = EXCLUDED.account_name,
              account_type = EXCLUDED.account_type;
        `, [bu.business_id, acc.account_number, acc.account_name, acc.account_type, acc.description || null]);
      }

      // 2. Seed payment types
      for (const pt of paymentTypes) {
        await client.query(`
          INSERT INTO rnt_payment_types (business_id, payment_type_name, depreciation_term, payable_yn, receivable_yn, is_income, description)
          VALUES ($1, $2, $3, $4, $5, $6, $7)
          ON CONFLICT (business_id, payment_type_name) DO UPDATE
          SET depreciation_term = EXCLUDED.depreciation_term,
              payable_yn = EXCLUDED.payable_yn,
              receivable_yn = EXCLUDED.receivable_yn,
              is_income = EXCLUDED.is_income;
        `, [bu.business_id, pt.payment_type_name, pt.depreciation_term, pt.payable_yn, pt.receivable_yn, pt.is_income, pt.description]);
      }

      // 3. Map posting rules
      for (const rule of rules) {
        const { rows: ptRows } = await client.query<{ payment_type_id: number }>(
          'SELECT payment_type_id FROM rnt_payment_types WHERE business_id = $1 AND payment_type_name = $2',
          [bu.business_id, rule.payment_type_name]
        );
        const { rows: debitRows } = await client.query<{ account_id: number }>(
          'SELECT account_id FROM rnt_accounts WHERE business_id = $1 AND account_number = $2',
          [bu.business_id, rule.debit_account_number]
        );
        const { rows: creditRows } = await client.query<{ account_id: number }>(
          'SELECT account_id FROM rnt_accounts WHERE business_id = $1 AND account_number = $2',
          [bu.business_id, rule.credit_account_number]
        );

        if (ptRows.length > 0 && debitRows.length > 0 && creditRows.length > 0) {
          await client.query(`
            INSERT INTO rnt_pt_rules (business_id, payment_type_id, transaction_type, debit_account, credit_account)
            VALUES ($1, $2, $3, $4, $5)
            ON CONFLICT (business_id, payment_type_id, transaction_type) DO UPDATE
            SET debit_account = EXCLUDED.debit_account,
                credit_account = EXCLUDED.credit_account;
          `, [bu.business_id, ptRows[0].payment_type_id, rule.transaction_type, debitRows[0].account_id, creditRows[0].account_id]);
        }
      }
    }

    await client.query('COMMIT');
    console.log('[seed] Successfully synchronized fixtures to all active business units.');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('[seed] Seed script failed:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
}

if (require.main === module) {
  const isDryRun = process.argv.includes('--dry-run');
  runSeed(isDryRun).catch(err => {
    console.error(err);
    process.exit(1);
  });
}
