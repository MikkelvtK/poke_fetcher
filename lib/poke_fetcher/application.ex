defmodule PokeFetcher.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Cachex, name: :poke_fetcher_cache}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
