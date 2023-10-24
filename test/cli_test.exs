defmodule CliTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest PokeFetcher

  import PokeFetcher.CLI, only: [parse_args: 1, process: 1]

  @cache Application.compile_env(:poke_fetcher, :cache)

  describe "PokeFetcher.Cli.parse_args/1" do
    test "should fail when given no list" do
      assert_raise FunctionClauseError, fn -> parse_args("no list") end
    end

    test "should return :help when given --help or -h" do
      assert parse_args(["--help"]) == :help
      assert parse_args(["-h"]) == :help
    end

    test "should return 5 as default num when given no arguments" do
      assert parse_args([]) == 5
    end

    test "should return parsed options" do
      assert parse_args(["--num", "5"]) == 5
      assert parse_args(["-n", "5"]) == 5
    end

    test "should show help when given negative num" do
      assert parse_args(["--num", "-1"]) == :help
    end

    test "should return :help when given invalid options" do
      assert parse_args(["--invalid", "option"]) == :help
      assert parse_args(["--num", "abc"]) == :help
      assert parse_args(["-n", "abc"]) == :help
      assert parse_args(["abc"]) == :help
    end
  end

  describe "PokeFetcher.CLI.process/1" do
    setup do
      key = :pokemon

      data =
        Path.absname("test/test_data/pokemon.txt")
        |> File.read!()

      Cachex.put(@cache, key, data)

      [
        cache: @cache,
        key: key
      ]
    end

    property "should process the arg into pokemons", fixture do
      data =
        Cachex.get!(fixture.cache, fixture.key)
        |> Jason.decode!()
        |> get_in(["results", Access.all(), "name"])

      check all(
              num <- integer(),
              num > 0 and num <= 151
            ) do
        result = process(num)

        assert length(result) == num

        Enum.each(result, fn pokemon ->
          assert result.name in data
        end)
      end
    end
  end
end
