defmodule Heimdall do
  @moduledoc """
  Documentation for `Heimdall`.
  """

  def handle_message(message) do
    handler().handle_message(message)
  end

  defp handler do
    Application.get_env(:heimdall, :handler, Heimdall.DefaultHandler)
  end
end
