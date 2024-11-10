create type loan_type as enum (
    'mortgage',
    'credit',
    'car',
    'accessory',
    'medical'
);


create type loan_status as enum (
    'ongoing',
    'paid off'
);


create table if not exists loans (
    id text primary key default generate_ulid(),
    lender_id text not null references actors (id),
    borrower_id text not null references actors (id) check (borrower_id != lender_id),
    type loan_type not null,
    principal_amount decimal(15,2),
    interest_rate decimal(5,2),
    number_of_payments integer check (number_of_payments > 0),
    contractual_start_date date,
    contractual_end_date date,
    actual_end_date date,
    status loan_status,
    description text not null default ''
);

grant all on loans to api_user;
