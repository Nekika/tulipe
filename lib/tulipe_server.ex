defmodule TulipeServer do
  def child_spec(_options) do
    Bandit.child_spec(plug: TulipeServer.Router, scheme: :http, port: 9898)
  end
end
