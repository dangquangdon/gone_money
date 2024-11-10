create or replace function signup(email text, pass text) 
returns void
as $$
    insert into internal.auth_users (
        email,
        pass,
        role
    ) values (
        signup.email,
        signup.pass,
        'api_user'
    );
$$ language sql security definer;

grant execute on function signup(text,text) to anonymous;
