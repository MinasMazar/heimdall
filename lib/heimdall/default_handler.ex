defmodule Heimdall.DefaultHandler do
  require Logger

  def handle_message(params) do
    Logger.debug("(#{__MODULE__}) handling message #{inspect params}")
    "console.log(\"PONG\");"
  end
end
