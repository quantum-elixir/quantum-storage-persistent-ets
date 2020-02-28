defmodule QuantumStoragePersistentEtsTest do
  @moduledoc false

  use ExUnit.Case
  doctest QuantumStoragePersistentEts

  defmodule Scheduler do
    use Quantum, otp_app: :quantum_storage_persistent_ets
  end

  setup %{test: test} do
    storage =
      start_supervised!({QuantumStoragePersistentEts, name: Module.concat(__MODULE__, test)})

    assert :ok = QuantumStoragePersistentEts.purge(storage, A)
    assert :ok = QuantumStoragePersistentEts.purge(storage, B)

    {:ok, storage: storage}
  end

  describe "purge/1" do
    test "purges correct module", %{storage: storage} do
      assert :ok = QuantumStoragePersistentEts.add_job(storage, A, Scheduler.new_job())
      assert :ok = QuantumStoragePersistentEts.purge(storage, A)
      assert [] = QuantumStoragePersistentEts.jobs(storage, A)
    end

    test "does not purge incorrect module", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, A, job)
      assert :ok = QuantumStoragePersistentEts.purge(storage, B)
      assert [^job] = QuantumStoragePersistentEts.jobs(storage, A)
    end
  end

  describe "add_job/2" do
    test "adds job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, A, job)
      assert [^job] = QuantumStoragePersistentEts.jobs(storage, A)
    end
  end

  describe "delete_job/2" do
    test "deletes job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, A, job)
      assert :ok = QuantumStoragePersistentEts.delete_job(storage, A, job.name)
      assert [] = QuantumStoragePersistentEts.jobs(storage, A)
    end

    test "does not fail when deleting unknown job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, A, job)

      assert :ok = QuantumStoragePersistentEts.delete_job(storage, A, make_ref())
    end

    test "does not fail when deleting job from unknown scheduler", %{storage: storage} do
      assert :ok = QuantumStoragePersistentEts.delete_job(storage, A, make_ref())
    end
  end

  describe "update_job_state/2" do
    test "updates job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, A, job)
      assert :ok = QuantumStoragePersistentEts.update_job_state(storage, A, job.name, :inactive)
      assert [%{state: :inactive}] = QuantumStoragePersistentEts.jobs(storage, A)
    end

    test "does not fail when updating unknown job", %{storage: storage} do
      job = Scheduler.new_job()
      assert :ok = QuantumStoragePersistentEts.add_job(storage, A, job)

      assert :ok = QuantumStoragePersistentEts.update_job_state(storage, A, make_ref(), :inactive)
    end

    test "does not fail when updating job from unknown scheduler", %{storage: storage} do
      assert :ok = QuantumStoragePersistentEts.delete_job(storage, A, make_ref())
    end
  end

  describe "update_last_execution_date/2" do
    test "sets time on scheduler", %{storage: storage} do
      date = NaiveDateTime.utc_now()
      assert :ok = QuantumStoragePersistentEts.update_last_execution_date(storage, A, date)
      assert ^date = QuantumStoragePersistentEts.last_execution_date(storage, A)
    end

    test "sets time only on right scheduler", %{storage: storage} do
      date = NaiveDateTime.utc_now()
      assert :ok = QuantumStoragePersistentEts.update_last_execution_date(storage, A, date)
      assert :unknown = QuantumStoragePersistentEts.last_execution_date(storage, B)
    end
  end

  describe "last_execution_date/1" do
    test "gets time", %{storage: storage} do
      date = NaiveDateTime.utc_now()
      assert :ok = QuantumStoragePersistentEts.update_last_execution_date(storage, A, date)
      assert ^date = QuantumStoragePersistentEts.last_execution_date(storage, A)
    end

    test "get unknown otherwise", %{storage: storage} do
      assert :unknown = QuantumStoragePersistentEts.last_execution_date(storage, A)
    end
  end
end
