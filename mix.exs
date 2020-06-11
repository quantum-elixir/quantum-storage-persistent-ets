defmodule QuantumStoragePersistentEts.MixProject do
  @moduledoc false

  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :quantum_storage_persistent_ets,
      version: @version,
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      name: "Quantum Storage Persistent ETS",
      description: "Quantum Storage Adapter based on Persistent ETS",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      build_embedded: (System.get_env("BUILD_EMBEDDED") || "false") in ["1", "true"],
      dialyzer:
        [
          ignore_warnings: "dialyzer.ignore-warnings"
        ] ++
          if (System.get_env("DIALYZER_PLT_PRIV") || "false") in ["1", "true"] do
            [
              plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
            ]
          else
            []
          end
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
      exclude_patterns: [~r[priv/(tables|plts)]],
      links: %{
        "Changelog" =>
          "https://github.com/quantum-elixir/quantum-storage-persistent-ets/blob/master/CHANGELOG.md",
        "GitHub" => "https://github.com/quantum-elixir/quantum-storage-persistent-ets"
      }
    }
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/quantum-elixir/quantum-storage-persistent-ets",
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:persistent_ets, "~> 0.2"},
      {:quantum, "~> 3.0"},
      {:ex_doc, "~> 0.13", only: [:dev, :docs], runtime: false},
      {:excoveralls, "~> 0.13", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
