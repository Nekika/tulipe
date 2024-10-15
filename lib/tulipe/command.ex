defmodule Tulipe.Command do
  def parse(raw) when is_binary(raw) do
    case String.split(raw) do
      ["LIST"] -> {:ok, {:list, :all}}
      ["LIST", raw_event] -> parse_with_event(:list, raw_event)
      ["REPORT", raw_event] -> parse_with_event(:report, raw_event)
      _ -> {:error, :unknown_command}
    end
  end

  defp parse_with_event(command, raw_event) do
    with {:ok, event} <- Tulipe.Event.parse(raw_event) do
      {:ok, {command, event}}
    end
  end
end
