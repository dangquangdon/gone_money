-- use for internal stuff
create schema if not exists internal;

-- use the default `public` schema for api,
-- so no need to grant extra access manually.
create role anonymous nologin noinherit;
create role api_user nologin noinherit;
create role authenticator nologin noinherit nocreatedb nocreaterole nosuperuser;

grant anonymous to authenticator;
grant api_user to authenticator;
