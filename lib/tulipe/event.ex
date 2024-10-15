defmodule Tulipe.Event do
  defstruct(
    datetime: nil,
    type: nil
  )

  def new(type) do
    with {:ok, now} <- DateTime.now("Etc/UTC") do
      {:ok, %Tulipe.Event{datetime: now, type: type}}
    end
  end

  def new!(type) do
    {:ok, event} = new(type)
    event
  end
end
