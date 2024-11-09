use dotenv::dotenv;
use gone_money::cli;
use std::error::Error;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    dotenv().ok();
    let migration_dir = "./migrations";
    cli::cli::run(migration_dir).await;
    Ok(())
}
