defmodule TulipeServer.Command do
  def parse(raw) when is_binary(raw) do
    case String.split(raw) do
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

  def run({:list, type}) do
    list = Tulipe.Tracker.list(Tracking, type)
    {:ok, JSON.encode!(list)}
  end

  def run({:report, type}) do
    Tulipe.Tracker.report(Tracking, type)
    {:ok, "OK"}
  end
end
