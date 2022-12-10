defmodule Heimdall.MixProject do
  use Mix.Project

  def project do
    [
      app: :heimdall,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Heimdall.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:plug_socket, "~> 0.1"},
      {:jason, "~> 1.4"},
      {:tesla, "~> 1.0", only: :test}
    ]
  end
end
