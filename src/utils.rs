use std::env;

pub fn get_env(key: &str) -> String {
    match env::var(key) {
        Ok(val) => val,
        Err(e) => panic!("Failed to get environment variable for {}: {}", key, e),
    }
}
