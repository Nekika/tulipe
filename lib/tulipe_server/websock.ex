defmodule TulipeServer.WebSock do
  @behaviour WebSock

  def init(options) do
    filter = Keyword.get(options, :filter, [])
    Tulipe.Dispatcher.subscribe(filter)
    {:ok, nil}
  end

  def handle_in(_message, state) do
    {:ok, state}
  end

  def handle_info({:event, event}, state) do
    data = Jason.encode!(event)
    {:push, {:text, data}, state}
  end

  def terminate(_reason, state) do
    Tulipe.Dispatcher.unsubscribe()
    {:ok, state}
  end
end
