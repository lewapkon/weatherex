defmodule Weatherex.CLI do
  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    {[], [city]} = OptionParser.parse!(args)
    city
  end

  defp process(city) do
    IO.inspect(city)
  end
end