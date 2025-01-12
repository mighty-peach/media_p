defmodule MediaP.FlagsTest do
  alias MediaP.Flags
  use ExUnit.Case

  test "converts flags in url into list of only known flags" do
    # Arrange
    test_url = "/w_10,h_20,unknown_321/123.jpg"

    # Act
    result = Flags.parse(test_url, ["w", "h"])

    # Assert
    assert result == [w: 10, h: 20]
  end

  test "converts flags in url with additional segments into list of flags" do
    # Arrange
    test_url = "/test/w_10/test/123.jpg"

    # Act
    result = Flags.parse(test_url, ["w"], 1)

    # Assert
    assert result == [w: 10]
  end

  test "does nothing if there are no flags in the url" do
    # Arrange
    test_url = "/123.jpg"

    # Act
    result = Flags.parse(test_url, [])

    # Assert
    assert result == []
  end
end
