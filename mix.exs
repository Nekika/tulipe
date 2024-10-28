defmodule Tulipe.MixProject do
  use Mix.Project

  def project do
    [
      app: :tulipe,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Tulipe, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:cors_plug, "~> 3.0"},
      {:jason, "~> 1.0"},
      {:plug, "~> 1.16"},
      {:websock, "~> 0.5"},
      {:websock_adapter, "~> 0.5"}
    ]
  end
end
