defmodule Weatherex.Supervisor do
  use Supervisor

  def start_link(city) do
    Supervisor.start_link(__MODULE__, city)
  end

  def init(city) do
    children = [
      worker(Weatherex.HTTPHandler, [city]),
      worker(Weatherex.WSHandler, []),
      worker(Weatherex.TemperatureServer, []),
    ]

    supervise(children, strategy: :one_for_one)
  end
end