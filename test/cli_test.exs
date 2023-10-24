defmodule CliTest do
  use ExUnit.Case
  doctest PokeFetcher

  import PokeFetcher.CLI, only: [parse_args: 1]

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
end
