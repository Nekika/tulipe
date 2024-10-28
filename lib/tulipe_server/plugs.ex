defmodule TulipeServer.Plugs do
  def event_filter(conn, _opts) do
    types =
      conn.query_params
      |> Map.get("types", "")
      |> String.split(",", trim: true)

    Plug.Conn.assign(conn, :event_filter, types: types)
  end
end
