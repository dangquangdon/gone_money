create table if not exists payments (
    id text primary key default generate_ulid(),
    loan_id text not null references loans (id),
    payer_id text not null references actors (id),
    payment_date date,
    amount_paid decimal(15,2),
    interest_paid decimal(15,2),
    principal_paid decimal(15,2),
    payment_method varchar(50),
    created_at timestamp(0) with time zone not null default now()
);

grant all on payments to api_user;
