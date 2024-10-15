defmodule Tulipe.Event.Type do
  def parse(raw) do
    case String.trim(raw) do
      "VimEnter" -> {:ok, :vim_enter}
      "VimLeave" -> {:ok, :vim_leave}
      _ -> {:error, :unsupported_event}
    end
  end
end
