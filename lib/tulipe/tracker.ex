defmodule Tulipe.Tracker do
  use GenServer

  @default_config %{
    state: [],
    time_zone: "Etc/UTC"
  }

  def start_link(config \\ %{}) when is_map(config) do
    GenServer.start_link(__MODULE__, Map.merge(@default_config, config), name: Tracking)
  end

  def list(pid) do
    list(pid, :all)
  end

  def list(pid, event) do
    GenServer.call(pid, {:list, event})
  end

  def report(pid, event) do
    GenServer.cast(pid, {:report, event})
  end

  @impl true
  def init(config) do
    with {:ok, _datetime} <- DateTime.now(config.time_zone) do
      {:ok, config}
    end
  end

  @impl true
  def handle_call({:list, :all}, _from, %{state: state} = config) do
    {:reply, state, config}
  end

  @impl true
  def handle_call({:list, event}, _from, %{state: state} = config) do
    events = Enum.filter(state, fn {e, _} -> e == event end)
    {:reply, events, config}
  end

  @impl true
  def handle_cast({:report, event}, %{state: state, time_zone: time_zone} = config) do
    new_event = {event, DateTime.now!(time_zone)}
    {:noreply, %{config | state: [new_event | state]}}
  end
end
