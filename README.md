# Quantum Storage Persistent Ets

[![Financial Contributors on Open Collective](https://opencollective.com/quantum/all/badge.svg?label=financial+contributors)](https://opencollective.com/quantum)
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

### Code Contributors

This project exists thanks to all the people who contribute.
<a href="https://github.com/quantum-elixir/quantum-storage-persistent-ets/graphs/contributors"><img src="https://opencollective.com/quantum/contributors.svg?width=890&button=false" /></a>

### Financial Contributors

Become a financial contributor and help us sustain our community. [[Contribute](https://opencollective.com/quantum/contribute)]

#### Individuals

<a href="https://opencollective.com/quantum"><img src="https://opencollective.com/quantum/individuals.svg?width=890"></a>

#### Organizations

Support this project with your organization. Your logo will show up here with a link to your website. [[Contribute](https://opencollective.com/quantum/contribute)]

<a href="https://opencollective.com/quantum/organization/0/website"><img src="https://opencollective.com/quantum/organization/0/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/1/website"><img src="https://opencollective.com/quantum/organization/1/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/2/website"><img src="https://opencollective.com/quantum/organization/2/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/3/website"><img src="https://opencollective.com/quantum/organization/3/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/4/website"><img src="https://opencollective.com/quantum/organization/4/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/5/website"><img src="https://opencollective.com/quantum/organization/5/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/6/website"><img src="https://opencollective.com/quantum/organization/6/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/7/website"><img src="https://opencollective.com/quantum/organization/7/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/8/website"><img src="https://opencollective.com/quantum/organization/8/avatar.svg"></a>
<a href="https://opencollective.com/quantum/organization/9/website"><img src="https://opencollective.com/quantum/organization/9/avatar.svg"></a>

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
