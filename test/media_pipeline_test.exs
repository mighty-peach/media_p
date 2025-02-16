defmodule MediaP.MediaPipelineTest do
  alias MediaP.MediaPipeline
  use ExUnit.Case

  @path Path.expand(__DIR__)
  @test_image Path.join([__DIR__, "assets", "test", "image.jpg"])

  test "returns correct file path" do
    request_path = "/image/test.jpg"

    result = MediaPipeline.get_file_path(request_path)

    assert result == %MediaP.FilePath{
             dir_name: "#{@path}/assets/original/",
             extension: "jpg",
             filename: "test.jpg",
             system_path: "#{@path}/assets/original/test.jpg",
             system_original_path: "#{@path}/assets/original/test.jpg"
           }
  end

  test "returns correctly wrapped cached image" do
    file = :image

    result = MediaPipeline.handle_from_cache(file)

    assert result == %MediaP.Media{file: :image, type: "image"}
  end

  test "returns correctly wrapped transformed image as proxy" do
    # Arrange
    file = File.read!(@test_image)
    request_path = "/test/123.jpg"

    Req.Test.stub(MediaP.Source, fn conn ->
      Req.Test.html(conn, file)
    end)

    # Act
    result = MediaPipeline.handle_downloaded(request_path)

    # Assert
    assert result == %MediaP.Media{file: file, type: "image"}
  end
end
