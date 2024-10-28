defmodule TulipeServer.Router do
  use Plug.Router

  import TulipeServer.Plugs

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:event_filter)

  plug(:dispatch)

  get "/events" do
    filter = Map.get(conn.assigns, :event_filter, [])
    data = Tulipe.Tracker.list(Tracking, filter)
    send_resp(conn, 200, Jason.encode!(data))
  end

  post "/events" do
    %{"type" => type} = conn.body_params

    {status, data} =
      case Tulipe.Event.new(type) do
        {:ok, event} ->
          Tulipe.Tracker.report(Tracking, event)
          {201, event}

        {:error, :unsupported_event_type} ->
          {400, %{error: "unsupported event type"}}
      end

    send_resp(conn, status, Jason.encode!(data))
  end

  get "events/stream" do
    filter = Map.get(conn.assigns, :event_filter, [])

    conn
    |> WebSockAdapter.upgrade(TulipeServer.WebSock, [filter: filter], [])
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
