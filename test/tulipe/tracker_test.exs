defmodule Tulipe.TrackerTest do
  use ExUnit.Case, async: true

  alias Tulipe.Tracker

  setup do
    tracker = start_supervised!({Tracker, name: TrackingTest})
    %{tracker: tracker}
  end

  test "track events", %{tracker: tracker} do
    event = %{type: "VimEnter", datetime: DateTime.now!("Etc/UTC")}

    assert :ok = Tracker.report(tracker, event)

    assert [^event] = Tracker.list(tracker)

    assert [] = Tracker.list(tracker, types: ["VimLeave"])

    assert [^event] = Tracker.list(tracker, types: ["VimEnter"])
  end
end
