defmodule Weatherex.CLI do

  @default_city "Warsaw"

  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    case OptionParser.parse!(args) do
      {[], [city]} -> city
      {[], []} -> @default_city
    end
  end

  defp process(city) do
    IO.inspect(city)
  end
end