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
             system_path: "/original/test.jpg"
           }
  end

  test "returns correct file path data for transformed media" do
    request_path = "/test/image/test.jpg"
    flags = [w: 10, h: 10]
    system_dir = %{original: "/original", transformed: "/transformed"}

    result = Path.get_file_path(request_path, flags, system_dir)

    assert result == %MediaP.FilePath{
             dir_name: "/transformed/w_10/h_10/",
             extension: "jpg",
             filename: "test.jpg",
             system_path: "/transformed/w_10/h_10/test.jpg"
           }
  end
end
