defmodule Tulipe.Tracker do
  use Agent

  def start_link(options \\ []) do
    events = Keyword.get(options, :events, [])
    name = Keyword.get(options, :name, Tracking)
    Agent.start_link(fn -> events end, name: name)
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
