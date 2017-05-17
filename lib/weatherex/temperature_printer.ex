defmodule Weatherex.TemperaturePrinter do
  defmacro __using__(_opts) do
    quote do
      defp print({{low_pid, _low}, _high} = data)
          when low_pid == self() do
        Weatherex.TemperaturePrinter.print(data)
      end

      defp print({{low_pid, _low}, _high} = data) do
        send low_pid, {:print, data}
      end
    end
  end

  def print({{_low_pid, {low_temp, low_city}}, {_high_pid, {high_temp, high_city}}}) do
    IO.puts("Lowest temperature (#{low_city}): #{low_temp}. Highest temperature (#{high_city}): #{high_temp}.")
  end
end