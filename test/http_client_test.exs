defmodule HttpClientTest do
  use ExUnit.Case
  doctest PokeFetcher

  describe "PokeFetcher.HttpClient.fetch/1" do
    test "should return pokemon" do
      {:ok, res} = PokeFetcher.HttpClient.fetch(:bulbasaur)
      assert Map.get(res, "name") == "bulbasaur"
    end

    test "should return error when given invalid name" do
      res = PokeFetcher.HttpClient.fetch(:test)
      assert {:error, "Not Found"} == res
    end
  end

  describe "PokeFetcher.HttpClient.fetch/0" do
    test "should return 151 pokemon" do
      {:ok, body} = PokeFetcher.HttpClient.fetch()
      assert length(body["results"]) == 151
    end
  end
end
