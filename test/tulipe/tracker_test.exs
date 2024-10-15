defmodule Tulipe.TrackerTest do
  use ExUnit.Case, async: true

  setup do
    tracker = start_supervised!(Tulipe.Tracker)
    %{tracker: tracker}
  end

  test "track events", %{tracker: tracker} do
    assert Tulipe.Tracker.list(tracker, :all) == []

    Tulipe.Tracker.report(tracker, :vim_enter)

    [event] = Tulipe.Tracker.list(tracker, :all)
    assert event.type == :vim_enter

    [event] = Tulipe.Tracker.list(tracker, :vim_enter)
    assert event.type == :vim_enter

    assert Tulipe.Tracker.list(tracker, :vim_leave) == []
  end
end
