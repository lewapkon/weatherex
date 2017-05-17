defmodule Weatherex.TemperatureServer do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Saves given reading and if readings from at least two cities exist
  returns {pid, {temp, city}} tuples for the lowest and highest temperature.
  """
  def save_temperature(temp, pid, city) do
    case Agent.get_and_update(__MODULE__, fn
      %{^pid => {^temp, ^city}} = state ->
        {:noprint, state}
      state ->
        new_state = Map.put(state, pid, {temp, city})
        if Kernel.map_size(new_state) > 1 do
          {{:print, new_state}, new_state}
        else
          {:noprint, new_state}
        end
    end) do
      :noprint -> nil
      {:print, state} ->
        Enum.min_max_by(state, fn {_pid, {temp, _city}} -> temp end)
    end
  end
end