defmodule Tulipe.Command do
  alias Tulipe.Event

  defp do_parse("LIST") do
    {:ok, {:list, :all}}
  end

  defp do_parse("LIST:" <> event) do
    with {:ok, event} <- Event.parse(event) do
      {:ok, {:list, event}}
    end
  end

  defp do_parse("REPORT:" <> event) do
    with {:ok, event} <- Event.parse(event) do
      {:ok, {:report, event}}
    end
  end

  def parse(from) when is_binary(from) do
    from
    |> String.trim()
    |> do_parse()
  end
end
