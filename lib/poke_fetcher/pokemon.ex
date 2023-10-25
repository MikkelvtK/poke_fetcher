defmodule PokeFetcher.Pokemon do
  @moduledoc """
  Handles data related to Pokemon
  """
  @type t :: %__MODULE__{id: Integer.t(), name: String.t(), types: [String.t()]}

  @enforce_keys [:id, :name, :types]
  defstruct [:id, :name, :types]

  alias PokeFetcher.Pokemon

  @doc """
  This function takes the `body` of the returned and decoded by the API and creates a new 
  `Pokemon` from it.
  """
  @spec new(map()) :: t()
  def new(body) do
    %Pokemon{
      id: get_in(body, ["id"]),
      name: get_in(body, ["name"]),
      types: get_in(body, ["types", Access.all(), "type", "name"])
    }
  end

  def get_pokemon_list(pokemons, num) do
    pokemons
    |> get_in(["results", Access.all(), "name"])
    |> Enum.shuffle()
    |> Enum.take(num)
  end
end
