defmodule QuantumStorageEts.MixProject do
  @moduledoc false

  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :quantum_storage_ets,
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      name: "Quantum Storage ETS",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    %{
      maintainers: [
        "Jonatan Männchen"
      ],
      licenses: ["Apache License 2.0"],
      links: %{
        "Changelog" =>
          "https://github.com/quantum-elixir/quantum-storage-ets/blob/master/CHANGELOG.md",
        "GitHub" => "https://github.com/quantum-elixir/quantum-storage-ets"
      }
    }
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/quantum-elixir/quantum-storage-ets",
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:persistent_ets, "~> 0.1"},
      {:quantum, "~> 3.0-rc"},
      {:ex_doc, "~> 0.13", only: [:dev, :docs], runtime: false},
      {:excoveralls, "~> 0.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0-rc", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
