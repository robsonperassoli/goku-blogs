defmodule Boc.RouterTest do
  use ExUnit.Case, async: true

  import Plug.Test
  # import Plug.Conn

  test "/ returns home route" do
    conn =
      conn(:get, "/")
      |> Boc.Router.call([])

    assert conn.status === 200
    assert conn.resp_body =~ "Robson Perassoli"
    assert conn.resp_body =~ "Articles"
    assert conn.resp_body =~ "Hey! I’m Robson"
  end

  test "article page renders title and byline from front matter" do
    conn =
      conn(:get, "/structured-data-extraction-llms")
      |> Boc.Router.call([])

    assert conn.status === 200
    assert conn.resp_body =~ "<h1>LLM-Assisted Data Extraction</h1>"
    assert conn.resp_body =~ "September 12, 2025"
    refute conn.resp_body =~ ~s(<h1><a href="/">Robson Perassoli</a></h1>)
  end

  test "unmatched route returns 404" do
    conn =
      conn(:get, "/does-not-exist")
      |> Boc.Router.call([])

    assert conn.status === 404
    assert conn.resp_body === "not found"
  end
end
