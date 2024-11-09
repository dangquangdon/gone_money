create table if not exists gone.loans (
    id uuid default gen_random_uuid() primary key,
    lender_id uuid not null references gone.users (id),
    borrower_id uuid not null references gone.users (id),
    loan_type varchar(100),
    principal_amount decimal(15,2),
    interest_rate decimal(5,2),
    start_date date,
    end_date date,
    status VARCHAR(50)
);