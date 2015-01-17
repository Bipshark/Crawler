defmodule Crawler.Mixfile do
  use Mix.Project

  def project do
    [app: :crawler,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger, :httpoison]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
      [
          {:httpoison, "~> 0.5"},
          {:floki, "~> 0.0.5"},
          {:remix, "~> 0.0.1", only: :dev}
      ]
  end
end
