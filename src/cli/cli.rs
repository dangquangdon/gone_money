use clap::{arg, Command};

use crate::db::{get_conn_str, GoneDb};

use super::{makemigration, pg_rest_config::write_rest_config, token};

fn cli() -> Command {
    Command::new("gone-money")
        .about("Gone money Dev CLI")
        .subcommand_required(true)
        .arg_required_else_help(true)
        .subcommand(
            Command::new("makemigration")
                .about("Create new migration file")
                .arg(arg!(-n --name [NAME] "Name of the migration file (Optional)")),
        )
        .subcommand(Command::new("migrate").about("Run migrations"))
        .subcommand(Command::new("make-rest-config").about("Create PostgREST config file"))
        .subcommand(Command::new("jwt-token").about("Get JWT Token for API Authentication header"))
}

pub async fn run(migration_dir: &str) {
    let matches = cli().get_matches();
    let mut store = GoneDb::new(migration_dir.to_string()).await;

    match matches.subcommand() {
        Some(("makemigration", sub_matches)) => {
            let name = sub_matches.get_one::<String>("name").map(|s| s.as_str());
            makemigration::generate_migration_file(migration_dir, name);
        }
        Some(("migrate", _)) => store.migrate().await,
        Some(("make-rest-config", _)) => {
            write_rest_config(get_conn_str());
        }
        Some(("jwt-token", _)) => {
            let token = token::generate_token();
            println!("Here is your token:");
            println!("{}", token);
        }
        _ => {
            println!("Invalid command")
        }
    }
}
