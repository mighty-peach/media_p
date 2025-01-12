defmodule MediaP.SourceTest do
  alias MediaP.Source
  use ExUnit.Case

  @path Path.expand("./", __DIR__)
  @test_image "#{@path}/assets/test/image.jpg"

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
