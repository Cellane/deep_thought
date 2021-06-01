use Mix.Config

slack_bot_token =
  System.get_env("SLACK_BOT_TOKEN") ||
    raise """
    environment variable SLACK_BOT_TOKEN is missing.
    """

slack_signing_secret =
  System.get_env("SLACK_SIGNING_SECRET") ||
    raise """
    environment variable SLACK_SIGNING_SECRET is missing.
    """

config :deep_thought, :slack,
  bot_token: slack_bot_token,
  signing_secret: slack_signing_secret
