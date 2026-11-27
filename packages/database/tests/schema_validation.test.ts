import * as fs from 'fs';
import * as path from 'path';

function runSchemaValidationTests(): void {
  console.log('====================================================');
  console.log('Running Schema Validation Test Suite for wp-01-schema');
  console.log('====================================================\n');

  let passCount = 0;
  let failCount = 0;

  function assert(condition: boolean, testName: string, detail?: string) {
    if (condition) {
      console.log(`[PASS] ${testName}`);
      passCount++;
    } else {
      console.error(`[FAIL] ${testName}${detail ? ` - ${detail}` : ''}`);
      failCount++;
    }
  }

  const migrationsDir = path.resolve(__dirname, '../migrations');
  const seedsDir = path.resolve(__dirname, '../seeds');

  // Test 1: Verify migration files exist
  const migration001Path = path.join(migrationsDir, '001_initial_schema.sql');
  const migration002Path = path.join(migrationsDir, '002_views.sql');
  assert(fs.existsSync(migration001Path), '001_initial_schema.sql exists');
  assert(fs.existsSync(migration002Path), '002_views.sql exists');

  const sql001 = fs.readFileSync(migration001Path, 'utf-8');
  const sql002 = fs.readFileSync(migration002Path, 'utf-8');

  // Test 2: Check required extensions
  assert(sql001.includes('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'), 'Extensions: uuid-ossp defined');
  assert(sql001.includes('CREATE EXTENSION IF NOT EXISTS "postgis"'), 'Extensions: PostGIS defined');
  assert(sql001.includes('CREATE EXTENSION IF NOT EXISTS "pgcrypto"'), 'Extensions: pgcrypto defined');

  // Test 3: Check set_updated_at trigger function
  assert(sql001.includes('CREATE OR REPLACE FUNCTION set_updated_at()'), 'Trigger Function: set_updated_at() defined');

  // Test 4: Verify all 32 active operational tables are declared
  const expectedTables = [
    'rnt_user_roles',
    'rnt_people',
    'rnt_business_units',
    'rnt_users',
    'rnt_user_assignments',
    'rnt_people_bu',
    'rnt_suppliers_all',
    'rnt_bu_suppliers',
    'rnt_section8_offices',
    'rnt_section8_offices_bu',
    'rnt_doc_templates',
    'rnt_properties',
    'rnt_property_units',
    'rnt_property_photos',
    'rnt_property_value',
    'rnt_property_expenses',
    'rnt_expense_items',
    'rnt_loans',
    'rnt_tenant',
    'rnt_tenancy_agreement',
    'rnt_agreement_actions',
    'rnt_leads',
    'rnt_lead_actions',
    'rnt_accounts',
    'rnt_account_periods',
    'rnt_payment_types',
    'rnt_pt_rules',
    'rnt_accounts_receivable',
    'rnt_payments',
    'rnt_payment_allocations',
    'rnt_accounts_payable',
    'rnt_ledger_entries'
  ];

  for (const table of expectedTables) {
    const tablePattern = new RegExp(`CREATE TABLE ${table}\\s*\\(`, 'i');
    assert(tablePattern.test(sql001), `Operational Table Declared: ${table}`);
  }

  // Test 5: Verify PostGIS spatial column and GiST index on rnt_properties
  assert(sql001.includes('geom geometry(Point, 4326)'), 'PostGIS: geom Point column with SRID 4326 declared');
  assert(sql001.includes('USING GIST(geom)'), 'PostGIS: GiST spatial index defined on rnt_properties(geom)');

  // Test 6: Verify complete decoupling from legacy external schemas (PR_* and MLS_*)
  assert(!sql001.includes('REFERENCES pr_'), 'Decoupling: No foreign keys to legacy PR_* county public records tables');
  assert(!sql001.includes('REFERENCES mls_'), 'Decoupling: No foreign keys to legacy MLS_* feeds tables');
  assert(sql001.includes('prop_id BIGINT'), 'Decoupling: rnt_properties includes unconstrained prop_id loose link');

  // Test 7: Verify Views in 002_views.sql
  const expectedViews = [
    'v_active_tenancy_agreements',
    'v_ar_aging',
    'v_account_period_balances',
    'v_ledger_transactions',
    'v_properties_summary'
  ];

  for (const viewName of expectedViews) {
    const viewPattern = new RegExp(`CREATE OR REPLACE VIEW ${viewName}\\s+AS`, 'i');
    assert(viewPattern.test(sql002), `ANSI SQL View Declared: ${viewName}`);
  }

  // Test 8: Security & Integrity constraints assertions
  assert(sql001.includes('requires_password_reset BOOLEAN NOT NULL DEFAULT FALSE'), 'Security: rnt_users has requires_password_reset column');
  assert(sql001.includes('CONSTRAINT rnt_ledger_distinct_accounts CHECK (debit_account <> credit_account)'), 'Integrity: rnt_ledger_entries enforces distinct debit and credit accounts');
  assert(sql001.includes('agreement_id BIGINT REFERENCES rnt_tenancy_agreement(agreement_id) ON DELETE SET NULL'), 'Integrity: rnt_accounts_receivable.agreement_id is nullable');
  assert(sql001.includes('business_id BIGINT NOT NULL REFERENCES rnt_business_units(business_id) ON DELETE CASCADE'), 'Integrity: rnt_accounts_receivable has business_id');
  assert(sql002.includes('COALESCE(ar.business_id, p.business_id, t.business_id) AS business_id'), 'Views: v_ar_aging includes robust business_id');

  // Test 9: Verify JSON fixtures parse properly
  const accountsFixture = path.join(seedsDir, 'default_accounts.json');
  const rulesFixture = path.join(seedsDir, 'default_pt_rules.json');
  const paymentTypesFixture = path.join(seedsDir, 'payment_types.json');

  assert(fs.existsSync(accountsFixture), 'Fixture: default_accounts.json exists');
  assert(fs.existsSync(rulesFixture), 'Fixture: default_pt_rules.json exists');
  assert(fs.existsSync(paymentTypesFixture), 'Fixture: payment_types.json exists');

  const accountsData = JSON.parse(fs.readFileSync(accountsFixture, 'utf-8'));
  const rulesData = JSON.parse(fs.readFileSync(rulesFixture, 'utf-8'));
  const paymentTypesData = JSON.parse(fs.readFileSync(paymentTypesFixture, 'utf-8'));

  assert(Array.isArray(accountsData) && accountsData.length > 20, `Fixture: default_accounts has ${accountsData.length} accounts (>20)`);
  assert(Array.isArray(rulesData) && rulesData.length > 10, `Fixture: default_pt_rules has ${rulesData.length} rules (>10)`);
  assert(Array.isArray(paymentTypesData) && paymentTypesData.length > 10, `Fixture: payment_types has ${paymentTypesData.length} types (>10)`);

  console.log('\n====================================================');
  console.log(`Summary: ${passCount} PASSED, ${failCount} FAILED`);
  console.log('====================================================');

  if (failCount > 0) {
    process.exit(1);
  }
}

if (require.main === module) {
  runSchemaValidationTests();
}
export { runSchemaValidationTests };
