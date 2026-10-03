fn main() -> anyhow::Result<()> {
    logging_config::setup_logging(None)?;
    zubanls::run_server(zubanls::Cli::default())
}
