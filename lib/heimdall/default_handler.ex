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
    handle_info(:pong, state)
  end

  def handle_info({_caller, "ping"}, state) do
    handle_info(:pong, state)
  end

  def handle_info({_caller, _}, state) do
    {:noreply, state}
  end

  @pong """
  console.log("pong");
  setTimeout(function() {
    Heimdall.heimdallSend("ping");
  }, 4400);
  """
  def handle_info(:pong, state) do
    Heimdall.send_response(@pong)
    {:noreply, state}
  end

  def handle_message(state) do
    "console.log(\"pong\");"
  end
end
