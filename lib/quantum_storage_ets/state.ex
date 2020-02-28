defmodule QuantumStoragePersistentEts.State do
  @moduledoc false

  @type t :: %__MODULE__{schedulers: map}

  @enforce_keys [:schedulers, :name]
  defstruct schedulers: %{}, name: QuantumStoragePersistentEts
end
