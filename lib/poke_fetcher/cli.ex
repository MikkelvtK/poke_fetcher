defmodule PokeFetcher.CLI do
  @moduledoc """
  Holds main business logic
  """

  def main(argv) do
    case parse_args(argv) do
      :help -> print_usage()
      num -> process(num) |> IO.inspect()
    end
  end

  @doc """
  Parses the command line arguments given.

  ## Examples

      iex> PokeFetcher.Cli.parse_args(["--num", "5"])
      5

  """
  @spec parse_args([String.t()]) :: non_neg_integer() | atom()
  def parse_args(argv) do
    OptionParser.parse(argv,
      strict: [help: :boolean, num: :integer],
      aliases: [h: :help, n: :num]
    )
    |> parse_invalid_args()
    |> parse_helper()
  end

  defp parse_invalid_args({parsed, [], []}), do: {:ok, parsed}
  defp parse_invalid_args({_parsed, _args, _invalid}), do: {:error, :help}

  defp parse_helper({:error, _parsed}), do: :help
  defp parse_helper({:ok, []}), do: 5
  defp parse_helper({:ok, [num: num]}) when num > 0, do: num
  defp parse_helper({:ok, [help: _]}), do: :help
  defp parse_helper({:ok, _}), do: :help

  @doc """
  Process handles the situation when no arguments are given or a `num` is given.
  It will fetch a full list of pokemons from the api. It will shuffle that list.
  Then it will take `num` amounts of Pokemons from that list to get more details for.
  """
  @spec process(non_neg_integer()) :: [PokeFetcher.Pokemon.t()]
  def process(num) do
    PokeFetcher.HttpClient.fetch()
    |> handle_error()
    |> PokeFetcher.Pokemon.get_pokemon_list(num)
    |> pmap(&process_pokemon/1)
  end

  defp handle_error({:ok, res}), do: res

  defp handle_error({:error, msg}) do
    IO.puts(:stderr, "error fetching from api: #{msg}")
    System.halt(1)
  end

  defp process_pokemon(pokemon) do
    pokemon
    |> String.to_atom()
    |> PokeFetcher.HttpClient.fetch()
    |> handle_error()
    |> PokeFetcher.Pokemon.new()
  end

  defp pmap(pokemons, func) do
    pokemons
    |> Enum.map(fn pokemon -> Task.async(fn -> func.(pokemon) end) end)
    |> Enum.map(fn tsk -> Task.await(tsk) end)
  end

  defp print_usage do
    IO.puts("""
    Returns random Pokemons.

    Options
      --num, -n <integer>   returns num amount of pokemons
      --help, -h            prints help
    """)
  end
end
