defmodule Publisher do
  use GenServer

  require Logger

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    state = %{
      interval: options[:interval] || 10_000,
      weather_tracker_url: options[:weather_tracker_url],
      sensors: options[:sensors],
      measurements: :no_measurements
    }

    schedule_next_publish(state.interval)

    {:ok, state}
  end

  defp schedule_next_publish(interval) do
    Process.send_after(self(), :publish_data, interval)
  end
end
