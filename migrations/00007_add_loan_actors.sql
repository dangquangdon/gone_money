create type actor_type as enum (
    'individual',
    'instituition'
);

create table if not exists actors (
    id text primary key default generate_ulid(),
    name varchar(100),
    type actor_type,
    email text unique references internal.auth_users (email),
    phone varchar(20),
    address text,
    created_at timestamp(0) with time zone not null default now()
);

grant all on actors to api_user;
