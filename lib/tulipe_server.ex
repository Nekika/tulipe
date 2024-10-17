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
    result =
      with {:ok, packet} <- recv(socket),
           {:ok, command} <- TulipeServer.Command.parse(packet),
           do: TulipeServer.Command.run(command)

    send_result(result, socket)

    serve_forever(socket)
  end

  defp recv(socket) do
    with {:ok, packet} <- :gen_tcp.recv(socket, 0) do
      Logger.info("Received packet from #{inspect(socket)}: #{inspect(packet)}")
      {:ok, packet}
    end
  end

  defp send_result({:ok, result}, socket) do
    send_message(result, socket)
  end

  defp send_result({:error, :unknown_command}, socket) do
    send_message("UNKNOWN COMMAND", socket)
  end

  defp send_result({:error, :unsupported_event}, socket) do
    send_message("UNSUPPORTED EVENT", socket)
  end

  defp send_message(message, socket) do
    :gen_tcp.send(socket, message <> "\r\n")
  end
end
