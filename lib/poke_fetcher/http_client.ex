defmodule PokeFetcher.HttpClient do
  @base_url "https://pokeapi.co/api/v2/pokemon/"
  @cache Application.compile_env(:poke_fetcher, :cache)

  @doc """
  Fetches all 151 original Pokemon using the base endpoint. 

  The function will first check if the result is already cached, in which case it will use the cached 
  value. If that's not the case it will make the call to the API to retrieve the values.
  """
  @spec fetch() :: {atom(), map()}
  def fetch() do
    _fetch(:pokemon, @base_url <> "?offset=0&limit=151")
  end

  @doc """
  Fetches the `pokemon` details from the API, must be provided as an atom

  The function will first check if the result is already cached, in which case it will use the cached 
  value. If that's not the case it will make the call to the API to retrieve the values.
  """
  @spec fetch(atom()) :: {atom(), map()}
  def fetch(pokemon) do
    _fetch(pokemon, "#{@base_url}#{pokemon}")
  end

  defp _fetch(key, url) do
    case Cachex.exists?(@cache, key) do
      {:ok, true} ->
        Cachex.get!(@cache, key)
        |> Jason.decode()

      {:ok, false} ->
        url
        |> HTTPoison.get()
        |> handle_response(key)
    end
  end

  defp handle_response({_, %{status_code: status_code, body: body}}, key) do
    Cachex.put(@cache, key, body)

    {
      check_for_error(status_code),
      decode(status_code, body)
    }
  end

  defp decode(200, body), do: Jason.decode!(body)
  defp decode(_, body), do: body

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
