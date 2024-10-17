defmodule Tulipe.Event do
  def new(type) do
    with {:ok, now} <- DateTime.now("Etc/UTC") do
      {:ok, %{datetime: now, type: type}}
    end
  end

  def new!(type) do
    {:ok, event} = new(type)
    event
  end
end
