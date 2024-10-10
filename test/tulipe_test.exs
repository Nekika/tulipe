defmodule TulipeTest do
  use ExUnit.Case
  doctest Tulipe

  test "greets the world" do
    assert Tulipe.hello() == :world
  end
end
