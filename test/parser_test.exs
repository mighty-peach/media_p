defmodule MediaP.ParserTest do
  alias MediaP.Parser
  use ExUnit.Case

  doctest MediaP.Parser

  test "returns list of tuples with transformation params" do
    origin = Application.fetch_env!(:media_p, :origin)
    test_url = "#{origin}/w_10,h_20,unknown_123/123.jpg"

    assert Parser.parse(test_url) == [w: 10, h: 20]
  end

  test "returns empty list if no params" do
    origin = Application.fetch_env!(:media_p, :origin)
    test_url = "#{origin}/123.jpg"

    assert Parser.parse(test_url) == []
  end
end
