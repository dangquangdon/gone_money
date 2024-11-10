create function login(email text, pass text, out token text) as $$
declare
  _role name;
begin
  -- check email and password
  select internal.user_role(email, pass) into _role;
  if _role is null then
    raise invalid_password using message = 'invalid user or password';
  end if;

  -- sign the token with email, role and let the token to be expired in 7 days
  select sign(
      row_to_json(r), 'kK+MZB2EkbyxIVDvS5PZAC3VAfBwa6oIln9HLdJRQ28='
    ) as token
    from (
      select _role as role, login.email as email,
         extract(epoch from now())::integer + 60*60*24*7 as exp
    ) r
    into token;
end;
$$ language plpgsql security definer;

grant execute on function login(text,text) to anonymous;
