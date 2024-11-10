use std::fs::File;
use std::io::prelude::*;
use std::io::LineWriter;

use crate::utils::get_env;

pub fn write_rest_config(conn_str: String) {
    let file = File::create("gone_money.conf").unwrap();
    let mut writer = LineWriter::new(file);
    let schema = get_env("DB_SCHEMA");
    let web_anon_role = get_env("WEB_ANON_ROLE");
    let secret_key = get_env("SECRET_KEY");
    let port = get_env("SERVER_PORT");

    let db_uri = format!("db-uri = \"{}\"\n", conn_str);
    let db_schema = format!("db-schemas = \"{}\"\n", schema);
    let web_role = format!("db-anon-role = \"{}\"\n", web_anon_role);
    let jwt_secret = format!("jwt-secret = \"{}\"\n", secret_key);
    let server_port = format!("server-port = \"{}\"\n", port);

    writer.write_all(db_uri.as_bytes()).unwrap();
    writer.write_all(db_schema.as_bytes()).unwrap();
    writer.write_all(web_role.as_bytes()).unwrap();
    writer.write_all(jwt_secret.as_bytes()).unwrap();
    writer.write_all(server_port.as_bytes()).unwrap();

    println!("Config file added!")
}
