create extension if not exists "uuid-ossp";

create or replace function generate_ulid()
returns text language plpgsql AS $$
declare
    ts_part bigint := (extract(epoch from clock_timestamp()) * 1000)::bigint;
    rand_part uuid := uuid_generate_v4();
    result text := lpad(to_hex(ts_part), 12, '0') || substring(replace(rand_part::text, '-', '') from 1 for 20);
begin
    RETURN result;
end $$;
