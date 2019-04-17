defmodule Indexer.Fetcher.ValidatorsUpdater do
  @moduledoc """
  Updates metadata for cataloged validators
  """

  use GenServer
  use Indexer.Fetcher

  alias Explorer.Chain
  alias Explorer.Validator.MetadataRetriever

  def start_link([initial_state, gen_server_options]) do
    GenServer.start_link(__MODULE__, initial_state, gen_server_options)
  end

  @impl GenServer
  def init(state) do
    send(self(), :update_validators)

    {:ok, state}
  end

  @impl GenServer
  def handle_info(:update_validators, state) do
    {:ok, addresses} = Chain.stream_cataloged_validator_address_hashes([], &[&1 | &2])

    addresses
    |> Enum.reverse()
    |> MetadataRetriever.fetch_validators_metadata()
    |> update_metadata()

    Process.send_after(self(), :update_validators, :timer.hours(state.update_interval) * 24)

    {:noreply, state}
  end

  defp update_metadata(validators) do
    Chain.import(%{validators: %{params: validators}})
  end

end
