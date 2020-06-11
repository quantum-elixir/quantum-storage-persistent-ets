# Quantum Storage Persistent Ets

[![Hex.pm Version](http://img.shields.io/hexpm/v/quantum_storage_persistent_ets.svg)](https://hex.pm/packages/quantum_storage_persistent_ets)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/quantum_storage_persistent_ets)
![.github/workflows/elixir.yml](https://github.com/quantum-elixir/quantum-storage-persistent-ets/workflows/.github/workflows/elixir.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/quantum-elixir/quantum-storage-persistent-ets/badge.svg?branch=master)](https://coveralls.io/r/quantum-elixir/quantum-storage-persistent-ets?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/dt/quantum_storage_persistent_ets.svg)](https://hex.pm/packages/quantum_storage_persistent_ets)

Adds a persistent storage adapter for ETS.

## Installation

The package can be installed by adding `quantum_storage_persistent_ets` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:quantum_storage_persistent_ets, "~> 1.0"}
  ]
end
```

To enable the storage adpater, add this to your `config.exs`:

```elixir
use Mix.Config

config :quantum_test, QuantumTest.Scheduler,
  storage: QuantumStoragePersistentEts
```

The docs can be found at [https://hexdocs.pm/quantum_storage_persistent_ets](https://hexdocs.pm/quantum_storage_persistent_ets).

## Contribution

This project uses the [Collective Code Construction Contract (C4)](http://rfc.zeromq.org/spec:42/C4/)
for all code changes.

> "Everyone, without distinction or discrimination, SHALL have an equal right to become a Contributor under the
terms of this contract."

### tl;dr

1. Check for [open issues](https://github.com/quantum-elixir/quantum-storage-persistent-ets/issues) or [open a new issue](https://github.com/quantum-elixir/quantum-storage-persistent-ets/issues/new) to start
a discussion around [a problem](https://www.youtube.com/watch?v=_QF9sFJGJuc).
2. Issues SHALL be named as "Problem: _description of the problem_".
3. Fork the [quantum-storage-persistent-ets repository on GitHub](https://github.com/quantum-elixir/quantum-storage-persistent-ets) to start making your changes
4. If possible, write a test which shows that the problem was solved.
5. Send a pull request.
6. Pull requests SHALL be named as "Solution: _description of your solution_"
7. Your pull request is merged and you are added to the [list of contributors](https://github.com/quantum-elixir/quantum-storage-persistent-ets/graphs/contributors)

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
