defmodule Tulipe.Dispatcher do
  @channel "events"

  def child_spec(_options) do
    Registry.child_spec(keys: :duplicate, name: __MODULE__)
  end

  def dispatch(event) do
    Registry.dispatch(__MODULE__, @channel, fn entries ->
      entries
      |> Enum.filter(fn {_, filter} ->
        case filter[:types] do
          [] -> true
          types -> Enum.member?(types, event.type)
        end
      end)
      |> Enum.each(fn {pid, _} -> send(pid, {:event, event}) end)
    end)
  end

  def subscribe(filter) do
    Registry.register(__MODULE__, @channel, filter)
  end

  def unsubscribe() do
    Registry.unregister(__MODULE__, @channel)
  end
end
