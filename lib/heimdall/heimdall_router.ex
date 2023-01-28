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
    Logger.debug("#{__MODULE__} received request on '/heimdall' with params #{inspect conn.params}; dispatching to HTTP message handler")
    case handle_message(conn.params) do
      {:ok, response} -> send_resp(conn, 200, response)
      {:error, error} -> send_resp(conn, 404, error)
    end
  end

  match _ do
    Logger.debug("Not-found. '/heimdall' is the only endpoint here.")
    send_resp(conn, 404, "not-found")
  end
end
