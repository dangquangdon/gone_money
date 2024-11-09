use chrono::Utc;
use regex::Regex;
use std::{
    fs::{self, File},
    path::Path,
};

fn get_prefix_number(filename: &str) -> Option<u32> {
    let re = Regex::new(r"^(\d+)_").unwrap();

    if let Some(caps) = re.captures(filename) {
        return caps.get(1).map(|m| m.as_str().parse::<u32>().unwrap());
    }
    None
}

fn get_the_last_migration_number(dir: &str) -> u32 {
    let mut prefixes = Vec::<u32>::new();
    if let Ok(entries) = fs::read_dir(dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_file() {
                if let Some(name) = path.file_name().and_then(|n| n.to_str()) {
                    let prefix = get_prefix_number(name);
                    match prefix {
                        Some(p) => prefixes.push(p),
                        None => {}
                    }
                }
            }
        }
    }

    if prefixes.len() == 0 {
        return 0;
    }

    match prefixes.iter().max() {
        Some(number) => *number,
        None => panic!("Cannot find the last migration number."),
    }
}

fn get_next_migration_filename(name: Option<&str>, last_migration: u32) -> String {
    let next_migration = last_migration + 1;
    let next_migration_str = format!("{}", next_migration);

    let filename = match name {
        Some(n) => n.to_string(),
        None => get_default_filename(),
    };

    let mut prefix = String::from("00000");
    if next_migration_str.len() < 5 {
        let zeros = 5 - next_migration_str.len();
        prefix.replace_range(zeros..5, "");
        prefix = format!("{}{}", prefix, next_migration_str)
    } else {
        prefix = next_migration_str
    }

    return format!("{}_{}.sql", prefix, filename);
}

fn get_default_filename() -> String {
    let now = Utc::now();
    format!("{}", now.timestamp())
}

pub fn generate_migration_file(dir: &str, name: Option<&str>) {
    let last_migration_number = get_the_last_migration_number(dir);
    let next_migration_name = get_next_migration_filename(name, last_migration_number);
    let filepath = Path::new(dir).join(next_migration_name.clone());
    match File::create(filepath) {
        Ok(_) => println!(
            "New migration file {} added to {}",
            next_migration_name.clone(),
            dir
        ),
        Err(e) => println!(
            "Failed to create migration file {} in {}: {}",
            next_migration_name, dir, e,
        ),
    }
}
