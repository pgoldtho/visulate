-- =============================================================================
-- Sequence Reset Script: tools/migration/reset-sequences.sql
-- Subsystem: Property Management (pdb22.RNTMGR2 -> PostgreSQL 16+)
-- Description: Dynamically identifies all identity and serial sequences in the
--              current target schema and synchronizes their counter to
--              COALESCE(MAX(pk_column), 0) + 1 to prevent collision on new inserts.
-- =============================================================================

DO $$
DECLARE
    rec RECORD;
    v_max_id BIGINT;
    v_seq_name TEXT;
    v_target_schema TEXT := current_schema();
BEGIN
    RAISE NOTICE 'Starting dynamic sequence counter synchronization in schema %...', v_target_schema;

    FOR rec IN 
        SELECT 
            t.table_name,
            c.column_name,
            c.is_identity,
            c.column_default
        FROM information_schema.tables t
        JOIN information_schema.columns c 
          ON t.table_name = c.table_name 
         AND t.table_schema = c.table_schema
        WHERE t.table_schema = v_target_schema 
          AND t.table_type = 'BASE TABLE'
          AND (c.column_default LIKE 'nextval%' OR c.is_identity = 'YES')
        ORDER BY t.table_name, c.column_name
    LOOP
        -- Determine sequence name for identity or serial column
        v_seq_name := pg_get_serial_sequence(format('%I.%I', v_target_schema, rec.table_name), rec.column_name);

        IF v_seq_name IS NOT NULL THEN
            EXECUTE format('SELECT COALESCE(MAX(%I), 0) + 1 FROM %I.%I', rec.column_name, v_target_schema, rec.table_name)
               INTO v_max_id;
            
            EXECUTE format('SELECT setval(%L, %s, false)', v_seq_name, v_max_id);
            RAISE NOTICE 'Sequence % for %.% synchronized to %', v_seq_name, rec.table_name, rec.column_name, v_max_id;
        END IF;
    END LOOP;

    RAISE NOTICE 'Sequence synchronization complete for schema %.', v_target_schema;
END;
$$;
