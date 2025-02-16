defmodule MediaP.SourceTest do
  alias MediaP.Source
  use ExUnit.Case

  @test_image Path.join([__DIR__, "assets", "test", "image.jpg"])

  test "converts flags in url into list of only known flags" do
    # Arrange
    test_url = "https://media/123.jpg"
    file = File.read!(@test_image)

    Req.Test.stub(MediaP.Source, fn conn ->
      Req.Test.html(conn, file)
    end)

    # Act
    result = Source.download_image(test_url)

    # Assert
    assert file == result
  end
end
