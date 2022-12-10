defmodule Heimdall do
  @moduledoc """
  Documentation for `Heimdall`.
  """

  require Logger

  @register_name Heimdall.Registry
  def subscribe_handler(url_regex) do
    Registry.register(@register_name, :message, url_regex)
  end

  def send_response(message) do
    Registry.dispatch(Heimdall.Registry, :response, fn entries ->
      for {pid, _} <- entries do
        Logger.debug("Sending response to socket")
        send(pid, {:response, message})
      end
    end)
  end

  def handle_message(message) do
    handler().handle_message(message)
  end

  defp handler do
    Application.get_env(:heimdall, :handler, Heimdall.DefaultHandler)
  end
end
