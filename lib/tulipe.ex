defmodule Tulipe do
  use Application

  def start(_type, _args) do
    children = [
      {Tulipe.Tracker, []},
      {Task, fn -> TulipeServer.start(9898) end}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
