defmodule HeimdallTest do
  use ExUnit.Case
  doctest Heimdall

  defmodule Consumer do
    use GenServer
    import Heimdall

    def start_link(), do: GenServer.start_link(__MODULE__, nil)
    def handle_message(%{"message" => "setup"}), do: "ok"
    def handle_message(_), do: "fallback"
  end

  test "receives setup" do
    {:ok, consumer} = HeimdallTest.Consumer.start_link()
    {:ok, env} = Tesla.post(client(), "http://localhost:9069/heimdall", %{"message" => "setup"})

    assert_receive "ok", 1000
  end

  test "receives unknown message" do
    {:ok, consumer} = HeimdallTest.Consumer.start_link()
    {:ok, env} = Tesla.post(client(), "http://localhost:9069/heimdall", ["something strange"])

    refute_received "fallback"
  end

  test "unmatched request" do
    {:ok, consumer} = HeimdallTest.Consumer.start_link()
    {:ok, env} = Tesla.get(client(), "http://localhost:9069/unknown")

    refute_received "ok"
  end

  defp client do
    [
      {Tesla.Middleware.Headers, [{"Content-type", "application/json"}]},
      Tesla.Middleware.JSON
    ]
    |> Tesla.client()
  end
end
