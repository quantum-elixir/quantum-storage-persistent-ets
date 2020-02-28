defmodule QuantumStoragePersistentEtsTest do
  @moduledoc false

  use ExUnit.Case
  doctest QuantumStoragePersistentEts

  defmodule Scheduler do
    @moduledoc false

    use Quantum, otp_app: :quantum_storage_persistent_ets
  end

  setup %{test: test} do
    storage =
      start_supervised!({QuantumStoragePersistentEts, name: Module.concat(__MODULE__, test)})

    assert :ok = QuantumStoragePersistentEts.purge(storage)

    {:ok, storage: storage}
  end

  describe "purge/1" do
    test "purges correct module", %{storage: storage} do
      assert :ok = QuantumStoragePersistentEts.add_job(storage, Scheduler.new_job())
      assert :ok = QuantumStoragePersistentEts.purge(storage)
      assert :not_applicable = QuantumStoragePersistentEts.jobs(storage)
    end
  end

  describe "add_job/2" do
    test "adds job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, job)
      assert [^job] = QuantumStoragePersistentEts.jobs(storage)
    end
  end

  describe "delete_job/2" do
    test "deletes job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, job)
      assert :ok = QuantumStoragePersistentEts.delete_job(storage, job.name)
      assert [] = QuantumStoragePersistentEts.jobs(storage)
    end

    test "does not fail when deleting unknown job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, job)

      assert :ok = QuantumStoragePersistentEts.delete_job(storage, make_ref())
    end
  end

  describe "update_job_state/2" do
    test "updates job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, job)
      assert :ok = QuantumStoragePersistentEts.update_job_state(storage, job.name, :inactive)
      assert [%{state: :inactive}] = QuantumStoragePersistentEts.jobs(storage)
    end

    test "does not fail when updating unknown job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, job)

      assert :ok = QuantumStoragePersistentEts.update_job_state(storage, make_ref(), :inactive)
    end
  end

  describe "update_last_execution_date/2" do
    test "sets time on scheduler", %{storage: storage} do
      date = NaiveDateTime.utc_now()
      assert :ok = QuantumStoragePersistentEts.update_last_execution_date(storage, date)
      assert ^date = QuantumStoragePersistentEts.last_execution_date(storage)
    end
  end

  describe "last_execution_date/1" do
    test "gets time", %{storage: storage} do
      date = NaiveDateTime.utc_now()
      assert :ok = QuantumStoragePersistentEts.update_last_execution_date(storage, date)
      assert ^date = QuantumStoragePersistentEts.last_execution_date(storage)
    end

    test "get unknown otherwise", %{storage: storage} do
      assert :unknown = QuantumStoragePersistentEts.last_execution_date(storage)
    end
  end
end
