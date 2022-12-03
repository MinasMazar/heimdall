defmodule Heimdall.Router do
  require Logger
  use Plug.Router
  use PlugSocket

  import Heimdall

  plug Plug.Parsers,
        parsers: [:json],
        pass:  ["application/json"],
        json_decoder: Jason
  socket "/heimdall/ws", Heimdall.SocketHandler
  plug :match
  plug :dispatch

  post "/heimdall" do
    Logger.debug("(#{__MODULE__}) Received message: #{inspect conn.params}")
    with response <- handle_message(conn.params) do
      send_resp(conn, 200, response)
    end
  end

  match _ do
    Logger.debug("Unmatched request")
    send_resp(conn, 404, "")
  end
end
