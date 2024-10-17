defmodule TulipeServer.Command do
  @doc ~S"""
  Parses `line` into a command.

  ## Examples

    iex> TulipeServer.Command.parse "LIST\r\n"
    {:ok, {:list, :all}}

    iex> TulipeServer.Command.parse "LIST VimEnter"
    {:ok, {:list, :vim_enter}}

    iex> TulipeServer.Command.parse "REPORT VimLeave"
    {:ok, {:report, :vim_leave}}

  Unknown commands or unsupported events lead to an error:

    iex> TulipeServer.Command.parse "MAKE VimEnter"
    {:error, :unknown_command}

    iex> TulipeServer.Command.parse "REPORT VimQuit"
    {:error, :unsupported_event}
  """
  def parse(line) when is_binary(line) do
    case String.split(line) do
      ["LIST"] -> {:ok, {:list, :all}}
      ["LIST", raw_type] -> parse_with_event(:list, raw_type)
      ["REPORT", raw_type] -> parse_with_event(:report, raw_type)
      _ -> {:error, :unknown_command}
    end
  end

  defp parse_with_event(command, raw_type) do
    with {:ok, type} <- Tulipe.Event.Type.parse(raw_type) do
      {:ok, {command, type}}
    end
  end

  @doc """
  Runs `command`.
  """
  def run(command)

  def run({:list, type}) do
    list = Tulipe.Tracker.list(Tracking, type)
    {:ok, JSON.encode!(list)}
  end

  def run({:report, type}) do
    Tulipe.Tracker.report(Tracking, type)
    {:ok, "OK"}
  end
end
