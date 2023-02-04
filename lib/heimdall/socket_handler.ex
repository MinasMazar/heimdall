defmodule Heimdall.SocketHandler do
  @behaviour :cowboy_websocket
  require Logger
  import Heimdall

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, message}, state) do
    websocket_handle({:json, Jason.decode!(message)}, state)
  end

  def websocket_handle({:json, json}, state) do
    Logger.debug("Received message #{inspect json}")
    dispatch_message(json)
    {:reply, {:text, "null"}, state}
  end

  def websocket_info({:response, response}, state) do
    Logger.debug("Received response for the client #{inspect response}")
    {:reply, {:text, response}, state}
  end

  def terminate(reason, _req, _state) do
    Logger.debug("Terminating websocket handler because of #{inspect reason}")
    Registry.unregister(Heimdall.Registry, :response)
  end
end
