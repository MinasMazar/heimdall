defmodule Heimdall.Router do
  require Logger
  use Plug.Router

   plug Plug.Parsers,
        parsers: [:json],
        pass:  ["application/json"],
        json_decoder: Jason
  plug :match
  plug :dispatch

  post "/heimdall" do
    with response <- handler().handle_message(conn.params) do
      send_resp(conn, 200, response)
    end
  end

  match _ do
    Logger.debug("Unmatched request")
    send_resp(conn, 404, "")
  end

  defp handler do
    Application.get_env(:heimdall, :handler, Heimdall.DefaultHandler)
  end
end
