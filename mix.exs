defmodule PokeFetcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :poke_fetcher,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {PokeFetcher.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:cachex, "~> 3.6"},
      {:stream_data, ">= 0.0.0"},
      {:ex_doc, "~> 0.27"}
    ]
  end

  defp escript_config() do
    [
      main_module: PokeFetcher.CLI
    ]
  end
end
