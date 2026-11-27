#!/usr/bin/env bash
# =============================================================================
# Multi-Environment Data Migration Execution Wrapper
# Supports --env=testbed (default pdb22) and --env=production cutover
# =============================================================================
set -euo pipefail

ENV_TARGET="${1:-testbed}"
ENV_TARGET="${ENV_TARGET#--env=}"
echo "=========================================================="
echo " Starting Data Migration Pipeline (Environment: ${ENV_TARGET})"
echo "=========================================================="

export MIGRATION_ENV="${ENV_TARGET}"

if [ "${ENV_TARGET}" = "testbed" ]; then
    echo "[INFO] Targeting TESTBED database (pdb22)..."
    export ORACLE_SERVICE_NAME="${ORACLE_SERVICE_NAME:-pdb22}"
    export ORACLE_USER="${ORACLE_USER:-RNTMGR2}"
    export PG_DATABASE="${PG_DATABASE:-property_mgmt_test}"
elif [ "${ENV_TARGET}" = "production" ]; then
    echo "[WARNING] Targeting DESIGNATED PRODUCTION Oracle database..."
    : "${ORACLE_HOST:?Environment variable ORACLE_HOST must be set for production cutover}"
    : "${ORACLE_SERVICE_NAME:?Environment variable ORACLE_SERVICE_NAME must be set for production cutover}"
    : "${ORACLE_USER:?Environment variable ORACLE_USER must be set for production cutover}"
    : "${ORACLE_PASSWORD:?Environment variable ORACLE_PASSWORD must be set for production cutover}"
    : "${PG_HOST:?Environment variable PG_HOST must be set for production cutover}"
    : "${PG_DATABASE:?Environment variable PG_DATABASE must be set for production cutover}"
    : "${PG_USER:?Environment variable PG_USER must be set for production cutover}"
    : "${PG_PASSWORD:?Environment variable PG_PASSWORD must be set for production cutover}"
else
    echo "[ERROR] Unknown environment: ${ENV_TARGET}. Use 'testbed' or 'production'."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Run Python Streaming ETL
echo "[INFO] Launching pure thin-mode Python streaming ETL..."
python "${SCRIPT_DIR}/etl_pipeline.py"

# 2. Reset Sequence Counters
echo "[INFO] Synchronizing PostgreSQL sequence counters..."
if [ "${ENV_TARGET}" = "production" ]; then
    export PGPASSWORD="${PG_PASSWORD}"
elif [ -n "${PG_PASSWORD:-}" ]; then
    export PGPASSWORD="${PG_PASSWORD}"
else
    echo "[WARNING] PG_PASSWORD not set; defaulting to 'postgres' for testbed environment only."
    export PGPASSWORD="postgres"
fi

psql -h "${PG_HOST:-localhost}" \
     -p "${PG_PORT:-5432}" \
     -U "${PG_USER:-postgres}" \
     -d "${PG_DATABASE:-property_mgmt_test}" \
     -f "${SCRIPT_DIR}/reset-sequences.sql"

echo "=========================================================="
echo " Data Migration Pipeline Completed Successfully"
echo "=========================================================="
