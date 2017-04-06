defmodule ChpokClient.Mixfile do
  use Mix.Project

  def project do
    [app: :chpok_client,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     escript: [main_module: ChpokClient] # Entry point for CLI
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {ChpokClient.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:remix, "~> 0.0.1", only: :dev},
      {:poison, "~> 2.0"},
      {:httpotion, "~> 3.0.2"},
      {:phoenix_channel_client, "~> 0.1.0"},
    ]
  end
end
