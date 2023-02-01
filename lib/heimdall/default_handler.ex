defmodule Heimdall.DefaultHandler do
  require Logger
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    Heimdall.subscribe_handler(~r[twitter\.com])
    {:ok, args}
  end

  def handle_info({_caller, "setup"}, state) do
    Logger.debug("Received setup!")
    Process.send_after(self(), :pong, 1400)
    {:noreply, state}
  end

  def handle_info({_caller, _}, state) do
    handle_info(:pong, state)
  end

  def handle_info(:pong, state) do
    Heimdall.send_response("console.log(\"pong\");")
    {:noreply, state}
  end

  def handle_message(state) do
    "console.log(\"pong\");"
  end
end
