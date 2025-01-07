defmodule MediaP.FileHandlerTest do
  alias MediaP.FileHandler

  use ExUnit.Case, async: false

  doctest MediaP.FileHandler

  @path Path.expand("./", __DIR__)
  @test_image "#{@path}/assets/test/image.jpg"
  @original_storage_path Application.compile_env!(:media_p, :original_path)
  @transformed_storage_path Application.compile_env!(:media_p, :transformed_path)

  defp clean do
    File.rm_rf(@original_storage_path)
    File.rm_rf(@transformed_storage_path)
  end

  setup do
    File.mkdir_p!(@original_storage_path)
    File.mkdir_p!(@transformed_storage_path)

    on_exit(&clean/0)
  end

  test "returns original if it is present" do
    # Arrange
    file_name = "test.jpg"
    original_file_path = "#{@original_storage_path}/#{file_name}"
    File.cp!(@test_image, original_file_path)

    # Act
    {:ok, path: path} = FileHandler.get_original(file_name)

    # Assert
    assert ^original_file_path = path
  end

  test "downloads original if it is not present" do
    # Arrange
    file_name = "test.jpg"
    file = File.read!(@test_image)

    Req.Test.stub(MediaP.FileHandler, fn conn ->
      Req.Test.html(conn, file)
    end)

    # Act
    {:ok, path: path} = FileHandler.get_original(file_name)

    # Assert
    assert File.exists?(path)
  end

  test "as a proxy returns transformed media if it is present" do
    # Arrange
    file_name = "test.jpg"
    transformed_file_path = "#{@transformed_storage_path}/w_10/h_10/#{file_name}"
    File.mkdir_p!(Path.dirname(transformed_file_path))
    File.cp!(@test_image, transformed_file_path)

    # Act
    {:ok, path: path} = FileHandler.get_transformed(["w_10", "h_10"], file_name, :proxy)

    # Assert
    assert ^transformed_file_path = path
  end

  test "as a proxy downloads transformed media if it is not present" do
    # Arrange
    file_name = "test.jpg"
    file = File.read!(@test_image)

    Req.Test.stub(MediaP.FileHandler, fn conn ->
      assert conn.request_path == "/w_10,h_10/#{file_name}"
      Req.Test.html(conn, file)
    end)

    # Act
    {:ok, path: path} = FileHandler.get_transformed(["w_10", "h_10"], file_name, :proxy)

    # Assert
    assert File.exists?(path)
  end
end
