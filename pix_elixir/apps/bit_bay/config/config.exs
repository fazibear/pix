import Config

config :bit_bay,
  ticker: ["BTCPLN", "ETHPLN"],
  wallet: Secrets.get!(:wallet)
