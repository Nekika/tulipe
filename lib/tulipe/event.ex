defmodule Tulipe.Event do
  @supported_events [
    "VimEnter",
    "VimLeave"
  ]

  def new(type) do
    if supported?(type) do
      event = %{datetime: DateTime.now!("Etc/UTC"), type: type}
      {:ok, event}
    else
      {:error, :unsupported_event_type}
    end
  end

  def supported?(type), do: Enum.member?(@supported_events, type)
end
