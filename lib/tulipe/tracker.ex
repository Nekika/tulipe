defmodule Tulipe.Tracker do
  use Agent

  def start_link(events \\ []) do
    Agent.start_link(fn -> events end, name: Tracking)
  end

  def list(tracker, :all) do
    Agent.get(tracker, fn events -> events end)
  end

  def list(tracker, type) do
    Agent.get(tracker, fn events ->
      Enum.filter(events, fn %{type: t} -> t == type end)
    end)
  end

  def report(tracker, type) do
    Agent.update(tracker, fn events ->
      event = Tulipe.Event.new!(type)
      [event | events]
    end)
  end
end
