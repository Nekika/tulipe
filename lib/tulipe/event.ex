defmodule Tulipe.Event do
  @raw_to_event %{
    "VimEnter" => :vim_enter,
    "VimLeave" => :vim_leave
  }

  @event_to_raw %{
    :vim_enter => "VimEnter",
    :vim_leave => "VimLeave"
  }

  def parse(raw) do
    case Map.get(@raw_to_event, raw) do
      nil -> {:error, :unknown_event}
      event -> {:ok, event}
    end
  end

  def to_string(event) do
    Map.get(@event_to_raw, event, "")
  end
end
