defmodule QuantumStoragePersistentEts.Application do
  @moduledoc false

  use Application

  def start(_type, _args),
    do:
      Supervisor.start_link([QuantumStoragePersistentEts],
        strategy: :one_for_one,
        name: QuantumStoragePersistentEts.Supervisor
      )
end
