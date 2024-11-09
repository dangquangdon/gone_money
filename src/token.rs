use chrono::{Duration, Utc};
use jsonwebtoken::{encode, EncodingKey, Header};
use serde::{Deserialize, Serialize};

use crate::utils::get_env;

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    role: String,
    exp: usize,
}

pub fn generate_token() -> String {
    let now = Utc::now();
    let token_duration = get_env("DEFAULT_EXP_TIME").parse::<i64>().unwrap();
    let secret = get_env("SECRET_KEY");
    let role = get_env("WEB_WRITE_ROLE");

    let exp = now
        .checked_add_signed(Duration::days(token_duration))
        .unwrap();
    let claim = &Claims {
        role,
        exp: exp.timestamp() as usize,
    };
    let token = encode(
        &Header::default(),
        claim,
        &EncodingKey::from_secret(secret.as_ref()),
    );

    match token {
        Ok(t) => t,
        Err(e) => panic!("Failed to generate JWT token: {}", e),
    }
}
