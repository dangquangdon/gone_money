-- internal table to store user authentication info
create table if not exists internal.auth_users (
  email    text primary key check ( email ~* '^.+@.+\..+$' ),
  pass     text not null check (length(pass) < 512),
  role     name not null check (length(role) < 512)
);

-- create trigger for checking roles when new user is added.
create function internal.check_role_exists() returns trigger as $$
begin
  if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
    raise foreign_key_violation using message =
      'unknown database role: ' || new.role;
    return null;
  end if;
  return new;
end
$$ language plpgsql;

create constraint trigger ensure_user_role_exists
  after insert or update on internal.auth_users
  for each row
  execute procedure internal.check_role_exists();

-- encrypt user password
create extension pgcrypto;

create function internal.encrypt_pass() returns trigger as $$
begin
  if tg_op = 'INSERT' or new.pass <> old.pass then
    new.pass = crypt(new.pass, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

create trigger encrypt_pass
  before insert or update on internal.auth_users
  for each row
  execute procedure internal.encrypt_pass();

-- check password
create function internal.user_role(email text, pass text) returns name
  language plpgsql
  as $$
begin
  return (
  select role from internal.auth_users u
   where u.email = user_role.email
     and u.pass = crypt(user_role.pass, u.pass)
  );
end;
$$;
