defmodule Weatherex.TemperaturePrinter do
  def print({{_low_pid, {low_temp, low_city}}, {_high_pid, {high_temp, high_city}}}) do
    IO.puts("Lowest temperature (#{low_city}): #{low_temp}. Highest temperature (#{high_city}): #{high_temp}.")
  end
end