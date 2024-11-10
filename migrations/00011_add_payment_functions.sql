-- get single payment by its ID
create or replace function get_payment(pid text)
returns setof payments
as $$
declare
    current_actor actors%rowtype;
begin
    current_actor := get_current_actor();

    return query select
                        id,
                        loan_id,
                        payer_id,
                        payment_date,
                        amount_paid,
                        interest_paid,
                        principal_paid,
                        payment_method,
                        created_at
                    from payments
                    where id = pid
                        and payer_id = current_actor.id;
end;
$$ language plpgsql security definer;

grant execute on function get_payment(text) to api_user;



-- get payments by loan
create or replace function get_payment_by_loan(loan_id text)
returns setof payments
as $$
declare
    current_actor actors%rowtype;
begin
    current_actor := get_current_actor();

    return query select
                        p.id,
                        p.loan_id,
                        p.payer_id,
                        p.payment_date,
                        p.amount_paid,
                        p.interest_paid,
                        p.principal_paid,
                        p.payment_method,
                        p.created_at
                    from payments p
                    where p.loan_id = get_payment_by_loan.loan_id
                        and p.payer_id = current_actor.id;
end;
$$ language plpgsql security definer;

grant execute on function get_payment_by_loan(text) to api_user;


-- create new payment
create or replace function create_payment(
    loan_id text,
    payment_date date,
    amount_paid numeric,
    payment_method varchar
) returns payments
as $$
declare
    current_actor actors%rowtype;
    loan loans%rowtype;
    paid_interest decimal;
    paid_principal decimal;
    new_payment payments%rowtype;
begin
    current_actor := get_current_actor();

    select * from loans where id = create_payment.loan_id into loan;

    paid_interest := create_payment.amount_paid * loan.interest;
    paid_principal := create_payment.amount_paid - paid_interest;

    insert into payments (
        loan_id,
        payer_id,
        payment_date,
        amount_paid,
        interest_paid,
        principal_paid,
        payment_method
    ) values (
        create_payment.loan_id,
        current_actor.id,
        create_payment.payment_date,
        create_payment.amount_paid,
        paid_interest,
        paid_principal,
        create_payment.payment_method
    ) returning * into new_payment;

    return new_payment;
end;
$$ language plpgsql security definer;

grant execute on function create_payment(text, date, numeric, varchar) to api_user;


-- delete payment
create or replace function delete_payment(pid text)
returns void
as $$
    delete from payments where id = pid;
$$ language sql security definer;
grant execute on function delete_payment(text) to api_user;
