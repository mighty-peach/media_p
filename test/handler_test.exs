defmodule MediaP.HandlerTest do
  alias MediaP.Source
  alias MediaP.Handler

  use ExUnit.Case, async: true
  use Mimic

  @test_image Path.join([__DIR__, "assets", "test", "image.jpg"])
  @systed_dir %{
    original: Application.compile_env!(:media_p, :original_path),
    transformed: Application.compile_env!(:media_p, :transformed_path)
  }

  setup :set_mimic_global

  test "Returns original image if it is in cache" do
    # Arrange
    file = File.read!(@test_image)
    request_path = "/just/image.webp"

    File
    |> stub(:exists?, fn _ -> true end)
    |> stub(:open!, fn _ -> file end)

    # Act
    {:ok, response} = Handler.handle(request_path)

    # Assert
    assert response.content_type == "image/webp"
    assert response.file_path == "#{@systed_dir.original}/image.webp"
  end

  test "Returns original image if there is no cache hit" do
    # Arrange
    request_path = "/just/image.webp"

    File
    |> stub(:exists?, fn _ -> false end)
    |> expect(:mkdir_p!, fn _ -> :ok end)
    |> expect(:write!, fn _, _ -> :ok end)

    Source
    |> expect(:download_image, fn _ -> :image end)

    # Act
    {:ok, response} = Handler.handle(request_path)

    # Assert
    assert response.content_type == "image/webp"
    assert response.file_path == "#{@systed_dir.original}/image.webp"
  end

  test "Returns transformed image if it is in cache" do
    # Arrange
    file = File.read!(@test_image)
    request_path = "/w_10,h_10/image.png"

    File
    |> stub(:exists?, fn _ -> true end)
    |> stub(:open!, fn _ -> file end)

    # Act
    {:ok, response} = Handler.handle(request_path)

    # Assert
    assert response.content_type == "image/png"
    assert response.file_path == "#{@systed_dir.transformed}/w_10/h_10/image.png"
  end

  test "Returns transformed image if there is no cache hit" do
    # Arrange
    request_path = "/w_10,h_10/image.png"

    File
    |> stub(:exists?, fn _ -> false end)
    |> expect(:mkdir_p!, fn _ -> :ok end)
    |> expect(:write!, fn _, _ -> :ok end)

    Source
    |> expect(:download_image, fn _ -> :image end)

    # Act
    {:ok, response} = Handler.handle(request_path)

    # Assert
    assert response.content_type == "image/png"
    assert response.file_path == "#{@systed_dir.transformed}/w_10/h_10/image.png"
  end
end
