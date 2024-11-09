create table if not exists gone.users (
    id uuid default gen_random_uuid() primary key,
    name varchar(100),
    email varchar(100),
    phone varchar(20),
    address text,
    created_at timestamp(0) with time zone not null default now()
);