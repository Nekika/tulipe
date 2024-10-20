defmodule TulipeServer do
  require Logger

  def start(port) do
    {:ok, listener} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Listening on port #{port}")

    accept_forever(listener)
  end

  defp log(socket, message) do
    Logger.info("[#{inspect(socket)}] " <> message)
  end

  defp accept_forever(listener) do
    with {:ok, socket} <- :gen_tcp.accept(listener) do
      log(socket, "Accepted new connection.")
      Task.start(fn -> serve_forever(socket) end)
      accept_forever(listener)
    end
  end

  defp serve_forever(socket) do
    receive_forever(socket, fn packet ->
      with {:ok, command} <- TulipeServer.Command.parse(packet),
           {:ok, response} <- TulipeServer.Command.run(command) do
        send_packet(response, socket)
        :continue
      else
        {:error, :unknown_command} ->
          send_packet("UNKNOWN COMMAND", socket)
          :continue

        {:error, :unsupported_event} ->
          send_packet("UNSUPPORTED EVENT", socket)
          :continue
      end
    end)
  end

  @spec receive_forever(socket, callback) :: :ok
        when socket: :gen_tcp.socket(),
             callback: (binary() -> :continue | {:stop, term()})
  defp receive_forever(socket, callback) do
    with {:ok, packet} <- receive_packet(socket),
         :continue <- callback.(packet) do
      receive_forever(socket, callback)
    else
      {:error, :closed} ->
        log(socket, "Connection has been closed by remote peer.")

      {:error, reason} ->
        log(socket, "An error has ocurrend while trying to receive packet: #{inspect(reason)}.")

      {:stop, reason} ->
        log(socket, "Reception loop stopped by the callback: #{inspect(reason)}")
    end
  end

  defp receive_packet(socket) do
    with {:ok, packet} = result <- :gen_tcp.recv(socket, 0) do
      log(socket, "Received packet: #{inspect(packet)}")
      result
    end
  end

  defp send_packet(packet, socket) do
    :gen_tcp.send(socket, packet <> "\n")
  end
end
