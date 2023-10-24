defmodule PokemonTest do
  use ExUnit.Case
  doctest PokeFetcher

  import PokeFetcher.Pokemon, only: [new: 1]

  alias PokeFetcher.Pokemon

  describe "PokeFetcher.Pokemon.new/1" do
    setup do
      {:ok, data} =
        Path.absname("test/test_data/bulbasaur.txt")
        |> File.read()

      [
        test_data: Jason.decode!(data)
      ]
    end

    test "should return pokemon struct with data", fixture do
      target = %Pokemon{id: 1, name: "bulbasaur", types: ["grass", "poison"]}
      assert new(fixture.test_data) |> Map.equal?(target)
    end
  end
end
