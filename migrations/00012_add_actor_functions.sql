-- create actor
create or replace function create_actor(
    name varchar(100),
    type actor_type,
    email text,
    phone varchar(20),
    address text
) returns payments
as $$
begin
    return query
        insert into actors (
                name,
                type,
                email,
                phone,
                address
            ) values (
                create_actor.name,
                create_actor.type,
                create_actor.email,
                create_actor.phone,
                create_actor.address
            ) returning *;
end;
$$ language plpgsql security definer;

grant execute on function create_actor(varchar, actor_type, text, varchar, text) to api_user;


-- get actor by email
create or replace function get_actor_by_email(actor_email text)
returns setof actors
as $$
begin
    return query
        select id, name, type, email, phone, address, created_at
            from actors where email = actor_email;
end;
$$ language plpgsql security definer;

grant execute on function get_actor_by_email(text) to api_user;
