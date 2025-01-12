defmodule MediaP.PathTest do
  alias MediaP.Path
  use ExUnit.Case

  test "returns extension" do
    test_url = "/w_10,h_20,unknown_321/123.jpg"

    result = Path.get_extension(test_url)

    assert result == "jpg"
  end

  test "returns filename" do
    test_url = "/w_10,h_20,unknown_321/123.jpg"

    result = Path.get_filename(test_url)

    assert result == "123.jpg"
  end

  test "returns correct system path for original media" do
    filename = "test.jpg"
    flags = []
    system_dir = %{original: "/original", transformed: "/transformed"}

    result = Path.get_system_path(filename, flags, system_dir)

    assert result == "/original/test.jpg"
  end

  test "returns correct system path for transformed media" do
    filename = "test.jpg"
    flags = [w: 10, h: 10]
    system_dir = %{original: "/original", transformed: "/transformed"}

    result = Path.get_system_path(filename, flags, system_dir)

    assert result == "/transformed/w_10/h_10/test.jpg"
  end

  test "returns correct download URL" do
    origin = "media.com"
    request_path = "/image/test.jpg"

    result = Path.get_download_url(origin, request_path)

    assert result == "https://media.com/image/test.jpg"
  end

  test "returns correct dir path for provided file path" do
    system_path = "/test/image/test.jpg"
    filename = "test.jpg"

    result = Path.get_dir_to_file(system_path, filename)

    assert result == "/test/image/"
  end
end
