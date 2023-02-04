defmodule Heimdall do
  @moduledoc """
  Documentation for `Heimdall`.
  """
  require Logger

  def subscribe_handler(url_regex) do
    Registry.register(Heimdall.Registry, :message, url_regex)
  end

  def dispatch_message(%{"location" => %{ "href" => ref, "host" => host}, "message" => message}) do
    Registry.dispatch(Heimdall.Registry, :message, fn entries ->
      for {pid, regex} <- entries do
        if Regex.run(regex, ref) do
          Logger.debug("Dispatching message #{inspect message}")
          Registry.register(Heimdall.Registry, :response, pid)
          send(pid, {{host, ref}, message})
        end
      end
    end)
  end

  def send_response(message) do
    Registry.dispatch(Heimdall.Registry, :response, fn entries ->
      for {pid, handler} <- entries do
        if handler == self() do
          Logger.debug("Sending response to socket")
          send(pid, {:response, message})
        end
      end
    end)
  end

  def handle_message(%{"location" => %{ "href" => ref, "host" => host}, "message" => 
message}) do
    Logger.debug("Handling message (v.2) -> {#{host}, #{ref}}: #{inspect message}")
    handler().handle_message({{host, ref}, message})
  end

  def handle_message(message) when is_map(message) do
    Logger.debug("Handling message (v.1) -> #{inspect message}")
    try do
      with {:ok, response} <- handler().handle_message(message) do
        {:ok, response}
      else
        response -> {:ok, response}
      end
    rescue
      FunctionClauseError -> {:error, "unknown"}
    end
  end

  def handle_message({{host, ref}, message}) when is_binary(message) do
    handler().handle_message({{host, ref}, message})
  end

  defp handler do
    Application.get_env(:heimdall, :handler, Heimdall.DefaultHandler)
  end
end
