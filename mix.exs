defmodule MediaP.MixProject do
  use Mix.Project

  def project do
    [
      app: :media_p,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MediaP, []},
      env: [port: 4000]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.5.0"},
      {:plug, "~> 1.0"},
      {:bandit, "~> 1.0"},
      {:mimic, "~> 1.10", only: :test}
    ]
  end
end
