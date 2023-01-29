defmodule Heimdall.DefaultHandler do
  require Logger
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    Heimdall.subscribe_handler(~r[git])
    {:ok, nil}
  end

  def handle_info({:message, message}, state) do
    Logger.debug("Received message #{inspect message}")
    Process.send_after(self(), :pong, 1400)
    {:noreply, state}
  end

  def handle_info(:pong, state) do
    Heimdall.send_response("console.log(\"poooong\");")
    {:noreply, state}
  end

  def handle_message(_) do
    "console.log(\"pong\");"
  end
end
