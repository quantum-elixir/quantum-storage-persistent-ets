defmodule QuantumStoragePersistentEts.State do
  @moduledoc false

  @type t :: %__MODULE__{table: :ets.tid()}

  @enforce_keys [:table]
  defstruct @enforce_keys
end
