import Config

defmodule Secrets do
  @secrets %{
    openweathermap_api_key: "...",
    wifi_name: "...",
    wifi_password: "...",
  }
  def get!(key) do
    @secrets[key]
  end
end
