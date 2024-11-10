create or replace function get_current_actor()
returns setof actors
as $$
declare
    current_email text;
begin
    select current_setting('request.jwt.claims', true)::json ->> 'email' into current_email;
    return query
        select id, name, type, email, phone, address, created_at
            from actors where email = current_email;
end;
$$ language plpgsql security definer;

grant execute on function get_current_actor() to api_user;
