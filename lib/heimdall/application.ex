defmodule Heimdall.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Heimdall.Worker.start_link(arg)
      cowboy_spec(),
      registry(),
      default_handler(),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Heimdall.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_spec do
    Plug.Cowboy.child_spec(
      scheme: :http,
      plug: Heimdall.Router,
      options: [port: port(), dispatch: dispatch()])
  end

  defp default_handler do
    Heimdall.DefaultHandler
  end

  defp registry do
    Registry.child_spec(
      keys: :unique,
      name: Heimdall.Registry
    )
  end

  defp dispatch, do: PlugSocket.plug_cowboy_dispatch(Heimdall.Router)
  defp port, do: Application.get_env(:heimdall, :port, 9069)
end
