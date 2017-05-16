defmodule Weatherex.HTTPHandler do
  use GenServer

  @interval 1000 * 3 # 3 seconds

  def start_link(city) do
    GenServer.start_link(__MODULE__, city)
  end

  def init(city) do
    schedule_request()
    {:ok, city}
  end

  def handle_info(:do_request, city) do
    city
    |> Weatherex.HTTPApi.get_temperature
    |> IO.inspect

    schedule_request()
    {:noreply, city}
  end

  defp schedule_request do
    Process.send_after(self(), :do_request, @interval)
  end
end