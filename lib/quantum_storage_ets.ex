defmodule QuantumStorageEts do
  @moduledoc """
  `PersistentEts` based implementation of a `Quantum.Storage`.
  """

  use GenServer

  require Logger

  alias __MODULE__.State

  @server __MODULE__

  @behaviour Quantum.Storage

  def start_link(opts),
    do: GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, @server))

  @impl GenServer
  def init(opts), do: {:ok, %State{schedulers: %{}, name: Keyword.get(opts, :name, @server)}}

  @impl Quantum.Storage
  def jobs(server \\ @server, scheduler_module),
    do: GenServer.call(server, {:jobs, scheduler_module})

  @impl Quantum.Storage
  def add_job(server \\ @server, scheduler_module, job),
    do: GenServer.call(server, {:add_job, scheduler_module, job})

  @impl Quantum.Storage
  def delete_job(server \\ @server, scheduler_module, job_name),
    do: GenServer.call(server, {:delete_job, scheduler_module, job_name})

  @impl Quantum.Storage
  def update_job_state(server \\ @server, scheduler_module, job_name, state),
    do: GenServer.call(server, {:update_job_state, scheduler_module, job_name, state})

  @impl Quantum.Storage
  def last_execution_date(server \\ @server, scheduler_module),
    do: GenServer.call(server, {:last_execution_date, scheduler_module})

  @impl Quantum.Storage
  def update_last_execution_date(server \\ @server, scheduler_module, last_execution_date),
    do:
      GenServer.call(server, {:update_last_execution_date, scheduler_module, last_execution_date})

  @impl Quantum.Storage
  def purge(server \\ @server, scheduler_module),
    do: GenServer.call(server, {:purge, scheduler_module})

  def purge_all(server \\ @server), do: GenServer.call(server, :purge_all)

  @impl GenServer
  def handle_call(
        {:add_job, scheduler_module, job},
        _from,
        %State{schedulers: schedulers, name: name} = state
      ) do
    {
      :reply,
      do_add_job(name, scheduler_module, job),
      %{
        state
        | schedulers:
            schedulers
            |> Map.put_new_lazy(scheduler_module, fn ->
              create_scheduler_module_atom(name, scheduler_module)
            end)
      }
    }
  end

  def handle_call(
        {:jobs, scheduler_module},
        _from,
        %State{schedulers: schedulers, name: name} = state
      ) do
    {
      :reply,
      do_get_jobs(name, scheduler_module),
      %{
        state
        | schedulers:
            schedulers
            |> Map.put_new_lazy(scheduler_module, fn ->
              create_scheduler_module_atom(name, scheduler_module)
            end)
      }
    }
  end

  def handle_call(
        {:delete_job, scheduler_module, job},
        _from,
        %State{schedulers: schedulers, name: name} = state
      ) do
    {
      :reply,
      do_delete_job(name, scheduler_module, job),
      %{
        state
        | schedulers:
            schedulers
            |> Map.put_new_lazy(scheduler_module, fn ->
              create_scheduler_module_atom(name, scheduler_module)
            end)
      }
    }
  end

  def handle_call(
        {:update_job_state, scheduler_module, job_name, job_state},
        _from,
        %State{schedulers: schedulers, name: name} = state
      ) do
    {
      :reply,
      do_update_job_state(name, scheduler_module, job_name, job_state),
      %{
        state
        | schedulers:
            schedulers
            |> Map.put_new_lazy(scheduler_module, fn ->
              create_scheduler_module_atom(name, scheduler_module)
            end)
      }
    }
  end

  def handle_call(
        {:last_execution_date, scheduler_module},
        _from,
        %State{schedulers: schedulers, name: name} = state
      ) do
    {
      :reply,
      do_get_last_execution_date(name, scheduler_module),
      %{
        state
        | schedulers:
            schedulers
            |> Map.put_new_lazy(scheduler_module, fn ->
              create_scheduler_module_atom(name, scheduler_module)
            end)
      }
    }
  end

  def handle_call(
        {:update_last_execution_date, scheduler_module, last_execution_date},
        _from,
        %State{schedulers: schedulers, name: name} = state
      ) do
    {
      :reply,
      do_update_last_execution_date(name, scheduler_module, last_execution_date),
      %{
        state
        | schedulers:
            schedulers
            |> Map.put_new_lazy(scheduler_module, fn ->
              create_scheduler_module_atom(name, scheduler_module)
            end)
      }
    }
  end

  def handle_call(
        {:purge, scheduler_module},
        _from,
        %State{schedulers: schedulers, name: name} = state
      ) do
    {
      :reply,
      do_purge(name, scheduler_module),
      %{
        state
        | schedulers:
            schedulers
            |> Map.put_new_lazy(scheduler_module, fn ->
              create_scheduler_module_atom(name, scheduler_module)
            end)
      }
    }
  end

  def handle_call(:purge_all, _from, %State{schedulers: schedulers, name: name} = state) do
    schedulers |> Map.values() |> Enum.each(fn scheduler -> :ok = do_purge(name, scheduler) end)
    {:reply, :ok, state}
  end

  defp create_scheduler_module_atom(storage_name, scheduler_module) do
    Module.concat(storage_name, scheduler_module)
  end

  defp job_key(job_name) do
    {:job, job_name}
  end

  defp get_ets_by_scheduler(storage_name, scheduler_module) do
    scheduler_module_atom = create_scheduler_module_atom(storage_name, scheduler_module)

    if ets_exist?(scheduler_module_atom) do
      scheduler_module_atom
    else
      path = Application.app_dir(:quantum_storage_ets, "priv/tables/#{scheduler_module_atom}.tab")

      File.mkdir_p!(Path.dirname(path))

      PersistentEts.new(scheduler_module_atom, path, [
        :named_table,
        :ordered_set
      ])
    end
  end

  defp ets_exist?(ets_name) do
    Logger.debug(fn ->
      "[#{inspect(Node.self())}][#{__MODULE__}] Determining whether ETS table with name [#{
        inspect(ets_name)
      }] exists"
    end)

    result =
      case :ets.info(ets_name) do
        :undefined -> false
        _ -> true
      end

    Logger.debug(fn ->
      "[#{inspect(Node.self())}][#{__MODULE__}] ETS table with name [#{inspect(ets_name)}] #{
        if result, do: ~S|exists|, else: ~S|does not exist|
      }"
    end)

    result
  end

  defp do_add_job(storage_name, scheduler_module, job) do
    table = get_ets_by_scheduler(storage_name, scheduler_module)
    :ets.insert(table, entry = {job_key(job.name), job})

    Logger.debug(fn ->
      "[#{inspect(Node.self())}][#{__MODULE__}] inserting [#{inspect(entry)}] into Persistent ETS table [#{
        table
      }]"
    end)

    :ok
  end

  defp do_get_jobs(storage_name, scheduler_module) do
    storage_name
    |> create_scheduler_module_atom(scheduler_module)
    |> ets_exist?()
    |> if do
      storage_name
      |> get_ets_by_scheduler(scheduler_module)
      |> :ets.match({{:job, :_}, :"$1"})
      |> List.flatten()
    else
      :not_applicable
    end
  end

  defp do_delete_job(storage_name, scheduler_module, job_name) do
    storage_name
    |> get_ets_by_scheduler(scheduler_module)
    |> :ets.delete(job_key(job_name))

    :ok
  end

  defp do_update_job_state(storage_name, scheduler_module, job_name, state) do
    table = get_ets_by_scheduler(storage_name, scheduler_module)

    table
    |> :ets.lookup(job_key(job_name))
    |> Enum.map(&{elem(&1, 0), %{elem(&1, 1) | state: state}})
    |> Enum.each(&:ets.update_element(table, elem(&1, 0), {2, elem(&1, 1)}))

    :ok
  end

  defp do_get_last_execution_date(storage_name, scheduler_module) do
    table = get_ets_by_scheduler(storage_name, scheduler_module)

    case :ets.lookup(table, :last_execution_date) do
      [] -> :unknown
      [{:last_execution_date, date} | _t] -> date
      {:last_execution_date, d} -> d
    end
  end

  defp do_update_last_execution_date(storage_name, scheduler_module, last_execution_date) do
    table = get_ets_by_scheduler(storage_name, scheduler_module)
    :ets.insert(table, {:last_execution_date, last_execution_date})
    :ok
  end

  defp do_purge(storage_name, scheduler_module) do
    table = get_ets_by_scheduler(storage_name, scheduler_module)
    :ets.delete_all_objects(table)
    :ok
  end
end
