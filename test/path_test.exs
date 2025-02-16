defmodule MediaP.PathTest do
  alias MediaP.Path
  use ExUnit.Case

  test "returns correct download URL" do
    origin = "media.com"
    request_path = "/image/test.jpg"

    result = Path.get_download_url(origin, request_path)

    assert result == "https://media.com/image/test.jpg"
  end

  test "returns correct file path data for original media" do
    request_path = "/test/image/test.jpg"
    flags = []
    system_dir = %{original: "/original", transformed: "/transformed"}

    result = Path.get_file_path(request_path, flags, system_dir)

    assert result == %MediaP.FilePath{
             dir_name: "/original/",
             extension: "jpg",
             filename: "test.jpg",
             system_path: "/original/test.jpg",
             system_original_path: "/original/test.jpg"
           }
  end

  test "returns correct file path data for transformed media" do
    request_path = "/test/image/test.jpg"
    flags = ["w_10", "h_10"]
    system_dir = %{original: "/original", transformed: "/transformed"}

    result = Path.get_file_path(request_path, flags, system_dir)

    assert result == %MediaP.FilePath{
             dir_name: "/transformed/w_10/h_10/",
             extension: "jpg",
             filename: "test.jpg",
             system_path: "/transformed/w_10/h_10/test.jpg",
             system_original_path: "/transformed/w_10/h_10/test.jpg"
           }
  end

  test "returns correct file path data for transformed media with segments before flags" do
    request_path = "/test/w_10,h_10/image/test.jpg"
    flags = ["w_10", "h_10"]
    system_dir = %{original: "/original", transformed: "/transformed"}
    segments = 1

    result = Path.get_file_path(request_path, flags, system_dir, segments)

    assert result == %MediaP.FilePath{
             dir_name: "/transformed/w_10/h_10/",
             extension: "jpg",
             filename: "test.jpg",
             original_path: "/test/image/test.jpg",
             system_path: "/transformed/w_10/h_10/test.jpg",
             system_original_path: "/original/test.jpg"
           }
  end

  test "returs original path correctly" do
    request_path = "/test/w_10/image/test.jpg"
    segments = 1

    result = Path.get_path_to_original(request_path, segments)

    assert result == "/test/image/test.jpg"
  end
end
