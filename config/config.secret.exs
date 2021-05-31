use Mix.Config

slack_signing_secret =
  System.get_env("SLACK_SIGNING_SECRET") ||
    raise """
    environment variable SLACK_SIGNING_SECRET is missing.
    """

config :deep_thought, :slack, signing_secret: slack_signing_secret
