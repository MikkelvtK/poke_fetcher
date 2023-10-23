defmodule PokeFetcher.Cli do
  def run(argv) do
    argv
    |> parse_args()
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
end
