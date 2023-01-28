defmodule HeimdallTest do
  use ExUnit.Case
  doctest Heimdall

  defmodule Consumer do
    use GenServer

    def start_link(), do: GenServer.start_link(__MODULE__, nil)
    def init(_), do: {:ok, Heimdall.subscribe_handler(~r[sitoweb])}
    def handle_message({_host, _ref, "setup"}), do: {:ok, "ok"}
  end

  test "receives setup" do
    {:ok, response} = Tesla.post(client(), "http://localhost:9069/heimdall", %{"message" => "setup", "location" => %{"href" => "https://siteweb.com", "host" => "siteweb.com"}})

    assert response.status == 200
    assert response.body == "ok"
  end

  test "receives unknown message" do
    {:ok, response} = Tesla.post(client(), "http://localhost:9069/heimdall", %{"message" => "something strange"})

    assert response.status == 404
    assert response.body == "unknown"
  end

  test "unmatched request" do
    {:ok, response} = Tesla.get(client(), "http://localhost:9069/unknown")

    assert response.status == 404
    assert response.body == "not-found"
  end

  defp client do
    [
      {Tesla.Middleware.Headers, [{"Content-type", "application/json"}]},
      Tesla.Middleware.JSON
    ]
    |> Tesla.client()
  end
end
