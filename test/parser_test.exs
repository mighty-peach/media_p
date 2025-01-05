defmodule MediaP.ParserTest do
  alias MediaP.Parser
  use ExUnit.Case

  doctest MediaP.Parser

  @origin Application.compile_env!(:media_p, :origin)

  test "converts flags in url into list of only known flags" do
    # Arrange
    test_url = "#{@origin}/w_10,h_20,unknown_123/123.jpg"

    # Act
    result = Parser.parse(test_url)

    # Assert
    assert result == [w: 10, h: 20]
  end

  test "does nothing if there are no flags in the url" do
    # Arrange
    test_url = "#{@origin}/123.jpg"

    # Act
    result = Parser.parse(test_url)

    # Assert
    assert result == []
  end
end
