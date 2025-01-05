defmodule MediaP.FileHandlerTest do
  alias MediaP.FileHandler
  import Mock

  use ExUnit.Case

  doctest MediaP.FileHandler

  @original_path Application.compile_env!(:media_p, :original_path)

  test "returns original if it is present" do
    # Arrange
    file_name = "test.jpg"
    existing_original = "#{@original_path}/#{file_name}"

    with_mocks([
      {File, [], [exists?: fn _path -> true end]},
      {Image, [], [open!: fn _path -> :image end]}
    ]) do
      # Act
      {:ok, image, path: path} = FileHandler.get_original(file_name)

      # Assert
      assert_called(Image.open!(existing_original))
      assert existing_original == path
      assert :image == image
    end
  end

  test "downloads original if it is not present" do
    # Arrange
    file_name = "test.jpg"
    original_path = "#{@original_path}/#{file_name}"

    with_mocks([
      {File, [], [exists?: fn _path -> false end]},
      {Req, [], [get: fn _url -> {:ok, %{body: :image}} end]},
      {Image, [],
       [
         open!: fn to_open -> to_open end,
         write: fn file, _ -> {:ok, file} end
       ]}
    ]) do
      # Act
      {:ok, image, path: path} = FileHandler.get_original(file_name)

      # Assert
      assert_called(Image.write(:image, original_path))
      assert original_path == path
      assert :image == image
    end
  end

  # test "downloads original if it is not present" do
  #   # Arrange
  #   {:ok, file} = File.read("#{@path}/assets/test/step-1-image.jpg")
  #
  #   Req.Test.stub(MediaP.FileHandler, fn conn ->
  #     Req.Test.html(conn, file)
  #   end)
  #
  #   # Act
  #   {:ok, image, path: path} = FileHandler.get_original("test.jpg")
  #
  #   # Assert
  #   assert %Vix.Vips.Image{} = image
  #   assert File.exists?(path)
  #
  #   # Cleaning
  #   File.rm(path)
  # end
  #
  # test "as a proxy returns transformed media if it is present" do
  #   # Arrange
  #   existing_media = "#{@path}/assets/transformed/w_10/h_10/test.jpg"
  #   dir_path = "#{@path}/assets/transformed/w_10/"
  #   File.mkdir_p!(Path.dirname(existing_media))
  #
  #   Image.open!("#{@path}/assets/test/step-1-image.jpg")
  #   |> Image.write!(existing_media)
  #
  #   # Act
  #   {:ok, image, _} = FileHandler.get_transformed(["w_10", "h_10"], "test.jpg", :proxy)
  #
  #   # Assert
  #   assert %Vix.Vips.Image{} = image
  #
  #   # Cleaning
  #   File.rm_rf(dir_path)
  # end
  #
  # test "as a proxy downloads transformed media if it is not present" do
  #   # Arrange
  #   {:ok, file} = File.read("#{@path}/assets/test/step-1-image.jpg")
  #
  #   Req.Test.stub(MediaP.FileHandler, fn conn ->
  #     assert conn.request_path == "/w_10,h_10/test.jpg"
  #     Req.Test.html(conn, file)
  #   end)
  #
  #   # Act
  #   {:ok, image, path: path} = FileHandler.get_transformed(["w_10", "h_10"], "test.jpg", :proxy)
  #
  #   # Assert
  #   assert %Vix.Vips.Image{} = image
  #   assert File.exists?(path)
  #
  #   # Cleaning File.rm(path)
  # end
end
