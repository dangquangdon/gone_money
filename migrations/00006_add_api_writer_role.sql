create role money_writter nologin;
grant money_writter to broke_dev;

grant usage on schema gone to money_writter;
grant all on gone.users to money_writter;
grant all on gone.loans to money_writter;
