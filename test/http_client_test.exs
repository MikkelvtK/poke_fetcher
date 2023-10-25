defmodule HttpClientTest do
  use ExUnit.Case
  doctest PokeFetcher

  @cache Application.compile_env(:poke_fetcher, :cache)
  @bulbasaur :bulbasaur
  @pokemon :pokemon

  describe "PokeFetcher.HttpClient.fetch/1" do
    setup do
      data =
        Path.absname("test/test_data/bulbasaur.txt")
        |> File.read!()

      Cachex.put(@cache, @bulbasaur, data)

      [
        cache: @cache,
        key: @bulbasaur
      ]
    end

    test "should return pokemon", fixture do
      {:ok, res} = PokeFetcher.HttpClient.fetch(fixture.key)
      assert Map.get(res, "name") == "bulbasaur"
    end
  end

  describe "PokeFetcher.HttpClient.fetch/0" do
    setup do
      data =
        Path.absname("test/test_data/pokemon.txt")
        |> File.read!()

      Cachex.put(@cache, @pokemon, data)

      [
        cache: @cache,
        key: @pokemon
      ]
    end

    test "should return 151 pokemon" do
      {:ok, body} = PokeFetcher.HttpClient.fetch()
      assert length(body["results"]) == 151
    end
  end
end
