use std::error::Error;
use std::path::Path;

use sqlx::migrate::Migrator;
use sqlx::postgres::PgConnection;
use sqlx::Connection;

use crate::utils::get_env;

#[derive(Debug)]
pub struct GoneDb {
    db: PgConnection,
    migration_dir: String,
}

impl GoneDb {
    pub async fn new(migration_dir: String) -> Self {
        let db = match init_db().await {
            Ok(db) => db,
            Err(e) => panic!("Failed to init connection: {}", e),
        };

        GoneDb { db, migration_dir }
    }

    pub async fn migrate(&mut self) {
        let dir = self.migration_dir.clone();
        let migrator = match Migrator::new(Path::new(&dir)).await {
            Ok(m) => m,
            Err(e) => panic!("Failed to start migration: {}", e),
        };

        return match migrator.run(&mut self.db).await {
            Ok(_) => println!("Migration ran successfully"),
            Err(e) => panic!("Failed to migrate: {}", e),
        };
    }

    pub fn get_migration_dir(self) -> String {
        return self.migration_dir;
    }

}

pub fn get_conn_str() -> String {
    let port = get_env("DB_PORT");
    let user = get_env("DB_USER");
    let pass = get_env("DB_PASS");
    let host = get_env("DB_HOST");
    let db_name = get_env("DB_NAME");

    return format!("postgres://{}:{}@{}:{}/{}", user, pass, host, port, db_name);
}

async fn init_db() -> Result<PgConnection, Box<dyn Error>> {
    let conn_str = &get_conn_str();
    let conn = PgConnection::connect(conn_str).await?;

    return Ok(conn);
}
