defmodule HeimdallTest do
  use ExUnit.Case
  doctest Heimdall

  defmodule Handler do
    def handle_message(%{"message" => "setup"}), do: "ok"
    def handle_message(_), do: "fallback"
  end

  test "receives setup" do
    {:ok, env} = Tesla.post(client(), "http://localhost:9069/heimdall", %{"message" => "setup"})
    assert env.status == 200
    assert env.body == "ok"
  end

  test "receives unknown message" do
    {:ok, env} = Tesla.post(client(), "http://localhost:9069/heimdall", ["something strange"])
    assert env.status == 200
    assert env.body == "fallback"
  end

  test "unmatched request" do
    {:ok, env} = Tesla.get(client(), "http://localhost:9069/unknown")
    assert env.status == 404
    assert env.body == ""
  end

  defp client do
    [
      {Tesla.Middleware.Headers, [{"Content-type", "application/json"}]},
      Tesla.Middleware.JSON
    ]
    |> Tesla.client()
  end
end
