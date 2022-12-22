pub fn getenv_unwrap(v: &str) -> String {
    match std::env::var(v) {
        Ok(s) => s,
        Err(_) => fail(&format!("environment variable `{}` not defined", v)),
    }
}

pub fn fail(s: &str) -> ! {
    panic!("\n{}\n\nbuild script failed, must exit now", s)
}
