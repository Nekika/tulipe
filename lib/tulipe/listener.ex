defmodule Tulipe.Listener do
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
      serve_forever(socket)
      accept_forever(listener)
    end
  end

  defp serve_forever(socket) do
    with {:ok, packet} <- :gen_tcp.recv(socket, 0) do
      Logger.info(packet)

      serve_forever(socket)
    end
  end
end
