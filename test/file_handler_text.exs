defmodule MediaPTest do
  alias MediaP.FileHandler
  use ExUnit.Case

  doctest MediaP.FileHandler

  setup(state) do
    transformed_path = Application.fetch_env!(:media_p, :transformed_path)
    original_path = Application.fetch_env!(:media_p, :original_path)

    state =
      state
      |> Map.put(:transformed_path, transformed_path)
      |> Map.put(:original_path, original_path)

    {:ok, state}
  end

  test "download_original downloads media and puts it to the correct path", state do
    original =
      "https://www.cats.org.uk/uploads/images/featurebox_main_small/step-1-image.jpg"

    {:ok, _image, file_name} = FileHandler.download_original(original)
    IO.inspect(file_name)

    # FIXME: mock Req in tests, so it returns image from /test folder

    file_path = "#{state.original_path}#{file_name}"

    assert File.exists?(file_path)

    # Cleaning
    File.rm(file_path)
  end

  test "test 1" do
  end
end
