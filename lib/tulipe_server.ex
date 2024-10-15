defmodule TulipeServer do
  require Logger

  def start(port) do
    {:ok, listener} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Listening on port #{port}")

    accept_forever(listener)
  end

  defp accept_forever(listener) do
    with {:ok, socket} <- :gen_tcp.accept(listener) do
      Logger.info("Accepted new connection")
      Task.start(fn -> serve_forever(socket) end)
      accept_forever(listener)
    end
  end

  defp serve_forever(socket) do
    with {:ok, packet} <- :gen_tcp.recv(socket, 0),
         {:ok, command} <- TulipeServer.Command.parse(packet),
         do: TulipeServer.Command.run(command)

    serve_forever(socket)
  end
end
