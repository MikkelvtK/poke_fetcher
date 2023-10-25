defmodule PokemonTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest PokeFetcher

  import PokeFetcher.Pokemon, only: [new: 1, get_pokemon_list: 2]

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

  describe "PokeFetcher.Pokemon.get_pokemon_list/2" do
    setup do
      data =
        Path.absname("test/test_data/pokemon.txt")
        |> File.read!()
        |> Jason.decode!()

      [
        data: data
      ]
    end

    property "should return list of pokemon equal to num", fixture do
      check all(num <- non_negative_integer()) do
        result = get_pokemon_list(fixture.data, num)
        assert length(result) == num
      end
    end

    property "should return values present in initial argument", fixture do
      check all(num <- non_negative_integer()) do
        result = get_pokemon_list(fixture.data, num)
        names = get_in(fixture.data, ["results", Access.all(), "name"])
        Enum.each(result, fn pokemon -> assert pokemon in names end)
      end
    end
  end
end
