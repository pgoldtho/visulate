"""
Configuration module for Oracle to PostgreSQL Data Extraction & Loading Pipeline.
Supports parameterization for Testbed (pdb22) rehearsal and designated Production cutover.
"""
import os
from dataclasses import dataclass
from dotenv import load_dotenv

load_dotenv()

@dataclass
class MigrationConfig:
    env_target: str = os.getenv("MIGRATION_ENV", "testbed")
    
    # Oracle Source Parameters
    oracle_host: str = os.getenv("ORACLE_HOST", "localhost")
    oracle_port: int = int(os.getenv("ORACLE_PORT", "1521"))
    oracle_service: str = os.getenv("ORACLE_SERVICE_NAME", "pdb22")
    oracle_user: str = os.getenv("ORACLE_USER", "RNTMGR2")
    oracle_password: str = os.getenv("ORACLE_PASSWORD", "")
    oracle_schema: str = os.getenv("ORACLE_SCHEMA", "RNTMGR2")
    
    # PostgreSQL Target Parameters
    pg_host: str = os.getenv("PG_HOST", "localhost")
    pg_port: int = int(os.getenv("PG_PORT", "5432"))
    pg_database: str = os.getenv("PG_DATABASE", "property_mgmt_test")
    pg_user: str = os.getenv("PG_USER", "postgres")
    pg_password: str = os.getenv("PG_PASSWORD", "postgres")
    pg_schema: str = os.getenv("PG_SCHEMA", "public")
    
    # Performance & Filters
    batch_size: int = int(os.getenv("ETL_BATCH_SIZE", "5000"))
    date_cutoff: str = os.getenv("ETL_DATE_CUTOFF", "2025-12-31 23:59:59")

def get_config() -> MigrationConfig:
    cfg = MigrationConfig()
    return cfg
