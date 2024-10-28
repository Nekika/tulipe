defmodule Tulipe.Tracker do
  use Agent

  def start_link(options \\ []) do
    events = Keyword.get(options, :events, [])
    name = Keyword.get(options, :name, Tracking)
    Agent.start_link(fn -> events end, name: name)
  end

  def list(tracker, options \\ []) do
    events = Agent.get(tracker, fn events -> events end)

    case Keyword.get(options, :types, []) do
      [] -> events
      types -> Enum.filter(events, fn event -> Enum.member?(types, event.type) end)
    end
  end

  def report(tracker, event) do
    Agent.update(tracker, fn events -> [event | events] end)
  end
end
