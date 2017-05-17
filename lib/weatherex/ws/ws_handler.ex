defmodule Weatherex.WSHandler do
  use Weatherex.TemperaturePrinter

  @behaviour :websocket_client
  @city "Bent Oaks, DeLand"
  @url "wss://ws.weatherflow.com/swd/data?api_key=20c70eae-e62f-4d3b-b3a4-8586e90f3ac8"
  @msg """
  {
    "type": "listen_start",
    "device_id": 1110,
    "id": "2098388936"
  }
  """

  def start_link do
    :crypto.start()
    :ssl.start()
    :websocket_client.start_link(@url, __MODULE__, [])
  end

  def init([]) do
    {:once, []}
  end

  def onconnect(_req, []) do
    {:ok, []}
  end

  def ondisconnect(_reason, []) do
    {:reconnect, []}
  end

  def websocket_handle({:pong, _}, _req, []) do
    {:ok, []}
  end

  def websocket_handle({:text, text}, _req, []) do
    data = text
    |> Poison.Parser.parse!

    case Map.fetch(data, "type") do
      {:ok, "obs_air"} ->
        %{"obs" => [[_, _, temp, _, _, _, _, _]]} = data
        case Weatherex.TemperatureServer.save_temperature(temp, self(), @city) do
          nil -> nil
          data -> print(data)
        end
        {:ok, []}
      {:ok, "connection_opened"} ->
        {:reply, {:text, @msg}, []}
      _ ->
        {:ok, []}
    end
  end

  def websocket_info({:print, data}, _req, []) do
    print(data)
    {:ok, []}
  end

  def websocket_terminate(reason, _req, []) do
    IO.puts("Websocket closed wih reason #{reason}\n")
    :ok
  end
end