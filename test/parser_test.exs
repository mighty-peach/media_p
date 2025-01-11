defmodule MediaP.ParserTest do
  alias MediaP.Parser
  use ExUnit.Case

  doctest MediaP.Parser

  @path_before_flags Application.compile_env!(:media_p, :path_before_flags)

  test "converts flags in url into list of only known flags" do
    # Arrange
    test_url = "#{@path_before_flags}/w_10,h_20,unknown_321/123.jpg"

    # Act
    result = Parser.parse(test_url)

    # Assert
    assert result == [w: 10, h: 20]
  end

  test "does nothing if there are no flags in the url" do
    # Arrange
    test_url = "#{@path_before_flags}/123.jpg"

    # Act
    result = Parser.parse(test_url)

    # Assert
    assert result == []
  end
end
