defmodule Weatherex.HTTPApi do
  def get_temperature(city) do
    city
    |> get_url
    |> HTTPoison.get
    |> handle_json
  end

  defp get_url(city) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=7dfc5c44b9669572522dab398e937a4e&units=metric"
  end

  defp handle_json({:ok, %{status_code: 200, body: body}}) do
    body
    |> Poison.Parser.parse!
    |> Map.fetch!("main")
    |> Map.fetch!("temp")
  end
end