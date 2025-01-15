defmodule MediaP.HandlerTest do
  alias MediaP.Source
  alias MediaP.Handler

  use ExUnit.Case, async: true
  use Mimic

  @path Path.expand("../", __DIR__)
  @test_image "#{@path}/test/assets/test/image.jpg"
  @systed_dir %{
    original: Application.compile_env!(:media_p, :original_path),
    transformed: Application.compile_env!(:media_p, :transformed_path)
  }

  setup :set_mimic_global

  test "Returns original image if it is in cache" do
    # Arrange
    file = File.read!(@test_image)
    current = self()
    request_path = "/just/image.webp"

    File
    |> stub(:exists?, fn _ -> true end)
    |> stub(:open!, fn _ -> file end)

    # Act
    spawn(fn -> Handler.handle(current, request_path) end)

    response =
      receive do
        {:ok, response} -> response
      end

    # Assert
    assert response.content_type == "image/webp"
    assert response.file_path == "#{@systed_dir.original}/image.webp"
  end

  test "Returns original image if there is no cache hit" do
    # Arrange
    current = self()
    request_path = "/just/image.webp"

    File
    |> stub(:exists?, fn _ -> false end)
    |> expect(:mkdir_p!, fn _ -> :ok end)
    |> expect(:write!, fn _, _ -> :ok end)

    Source
    |> expect(:download_image, fn _ -> :image end)

    # Act
    spawn(fn -> Handler.handle(current, request_path) end)

    response =
      receive do
        {:ok, response} -> response
      end

    # Assert
    assert response.content_type == "image/webp"
    assert response.file_path == "#{@systed_dir.original}/image.webp"
  end

  test "Returns transformed image if it is in cache" do
    # Arrange
    file = File.read!(@test_image)
    current = self()
    request_path = "/w_10,h_10/image.png"

    File
    |> stub(:exists?, fn _ -> true end)
    |> stub(:open!, fn _ -> file end)

    # Act
    spawn(fn -> Handler.handle(current, request_path) end)

    response =
      receive do
        {:ok, response} -> response
      end

    # Assert
    assert response.content_type == "image/png"
    assert response.file_path == "#{@systed_dir.transformed}/w_10/h_10/image.png"
  end

  test "Returns transformed image if there is no cache hit" do
    # Arrange
    current = self()
    request_path = "/w_10,h_10/image.png"

    File
    |> stub(:exists?, fn _ -> false end)
    |> expect(:mkdir_p!, fn _ -> :ok end)
    |> expect(:write!, fn _, _ -> :ok end)

    Source
    |> expect(:download_image, fn _ -> :image end)

    # Act
    spawn(fn -> Handler.handle(current, request_path) end)

    response =
      receive do
        {:ok, response} -> response
      end

    # Assert
    assert response.content_type == "image/png"
    assert response.file_path == "#{@systed_dir.transformed}/w_10/h_10/image.png"
  end
end
