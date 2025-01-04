defmodule MediaP.FileHandlerTest do
  alias MediaP.FileHandler
  use ExUnit.Case

  doctest MediaP.FileHandler

  @path Path.expand("./", __DIR__)

  test "get_original returns original if it exists" do
    existing_original = "#{@path}/assets/original/test.jpg"
    File.cp!("#{@path}/assets/test/step-1-image.jpg", existing_original)

    {:ok, image, _} = FileHandler.get_original("test.jpg")

    assert %Vix.Vips.Image{} = image

    # Cleaning
    File.rm(existing_original)
  end

  test "get_original downloads and returns original if it doesn't exist" do
    {:ok, file} = File.read("#{@path}/assets/test/step-1-image.jpg")

    Req.Test.stub(MediaP.FileHandler, fn conn ->
      Req.Test.html(conn, file)
    end)

    {:ok, image, path: path} = FileHandler.get_original("test.jpg")

    assert %Vix.Vips.Image{} = image
    assert File.exists?(path)

    # Cleaning
    File.rm(path)
  end

  test "get_transformed as proxy returns transformed media if it exists" do
    existing_media = "#{@path}/assets/transformed/w_10/h_10/test.jpg"
    dir_path = "#{@path}/assets/transformed/w_10/"
    File.mkdir_p!(Path.dirname(existing_media))

    Image.open!("#{@path}/assets/test/step-1-image.jpg")
    |> Image.write!(existing_media)

    {:ok, image, _} = FileHandler.get_transformed(["w_10", "h_10"], "test.jpg", :proxy)

    assert %Vix.Vips.Image{} = image

    # Cleaning
    File.rm_rf(dir_path)
  end

  test "get_transformed as proxy requests transformed media and writes it if it doesn't exists" do
    {:ok, file} = File.read("#{@path}/assets/test/step-1-image.jpg")

    Req.Test.stub(MediaP.FileHandler, fn conn ->
      assert conn.request_path == "/w_10,h_10/test.jpg"
      Req.Test.html(conn, file)
    end)

    {:ok, image, path: path} = FileHandler.get_transformed(["w_10", "h_10"], "test.jpg", :proxy)

    assert %Vix.Vips.Image{} = image
    assert File.exists?(path)

    Cleaning
    File.rm(path)
  end
end
