
role=$1
secondary=$2

if [[ "$secondary" =~ .*_ro$ ]]; then
    ro_role=$2
    echo 'BEGIN;'
    echo 'ALTER DEFAULT PRIVILEGES for role "'${role}'" IN SCHEMA public grant select on sequences to "'${ro_role}'";'
    echo 'ALTER DEFAULT PRIVILEGES FOR ROLE "'${role}'" GRANT SELECT ON TABLES TO "'${ro_role}'";'
    echo 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO "'${ro_role}'";'
    echo 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO "'${ro_role}'";'
    echo 'COMMIT;'
else
    rw_role=$2
    echo 'BEGIN;'
    echo 'ALTER DEFAULT PRIVILEGES for role "'${role}'" IN SCHEMA public grant select, usage on sequences to "'${rw_role}'";'
    echo 'ALTER DEFAULT PRIVILEGES FOR ROLE "'${role}'" GRANT SELECT,INSERT,DELETE,UPDATE,REFERENCES,TRIGGER ON TABLES TO "'${rw_role}'";'
    echo 'GRANT SELECT,INSERT,DELETE,UPDATE,REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA public TO "'${rw_role}'";'
    echo 'GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA public TO "'${rw_role}'";'
    echo 'COMMIT;'
fi