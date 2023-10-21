defmodule PokeFetcherTest do
  use ExUnit.Case
  doctest PokeFetcher

  test "greets the world" do
    assert PokeFetcher.hello() == :world
  end
end
