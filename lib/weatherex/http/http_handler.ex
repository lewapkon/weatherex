defmodule Weatherex.HTTPHandler do
  use GenServer
  use Weatherex.TemperaturePrinter

  @interval 1000 * 3 # 3 seconds

  def start_link(city) do
    GenServer.start_link(__MODULE__, city)
  end

  def init(city) do
    schedule_request()
    {:ok, city}
  end

  def handle_info(:do_request, city) do
    case (city
      |> Weatherex.HTTPApi.get_temperature
      |> Weatherex.TemperatureServer.save_temperature(self(), city)) do
        nil -> nil
        data -> print(data)
      end

    schedule_request()
    {:noreply, city}
  end

  def handle_info({:print, data}, city) do
    print(data)
    {:noreply, city}
  end

  defp schedule_request do
    Process.send_after(self(), :do_request, @interval)
  end
end