defmodule Heimdall.SocketHandler do
  @behaviour :cowboy_websocket
  require Logger

  import Heimdall

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do
    #Registry.register(Heimdall.Registry, __MODULE__, {})
    {:ok, %{}}
  end

  def websocket_handle({:text, message}, state) do
    websocket_handle({:json, Jason.decode!(message)}, state)
  end

  def websocket_handle({:json, json}, state) do
    Logger.debug("(#{__MODULE__}) Received message: #{inspect json}")
    with response <- handle_message(json) do
      {:reply, {:text, response}, state}
    end
  end

  def websocket_info(info, state) do
    {:reply, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
