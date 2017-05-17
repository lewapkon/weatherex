defmodule Weatherex.WSHandler do
  use Weatherex.TemperaturePrinter

  @behaviour :websocket_client
  @city "Bent Oaks, DeLand"
  @url "wss://ws.weatherflow.com/swd/data?api_key=20c70eae-e62f-4d3b-b3a4-8586e90f3ac8"
  @init_msg "{ \"type\": \"listen_start\", \"device_id\": 1110, \"id\": \"2098388936\" }"

  def start_link do
    :crypto.start()
    :ssl.start()
    :websocket_client.start_link(@url, __MODULE__, [])
  end

  def init(state) do
    {:once, state}
  end

  def onconnect(_req, state) do
    {:ok, state}
  end

  def ondisconnect(_reason, state) do
    {:reconnect, state}
  end

  def websocket_handle({:pong, _}, _req, state) do
    {:ok, state}
  end

  def websocket_handle({:text, text}, _req, state) do
    data = text
    |> Poison.Parser.parse!

    case Map.fetch(data, "type") do
      {:ok, "obs_air"} ->
        case Weatherex.TemperatureServer.save_temperature(
            get_temperature(data), self(), @city) do
          nil -> nil
          data -> print(data)
        end
        {:ok, state}

      {:ok, "connection_opened"} ->
        {:reply, {:text, @init_msg}, state}
      _ ->
        {:ok, state}
    end
  end

  defp get_temperature(%{"obs" => [[_, _, temp, _, _, _, _, _]]}), do: temp

  def websocket_info({:print, data}, _req, state) do
    print(data)
    {:ok, state}
  end

  def websocket_terminate(reason, _req, []) do
    IO.puts("Websocket closed wih reason #{reason}\n")
    :ok
  end
end