defmodule MediaP.FileHandler do
  @moduledoc """
  Helps working with media
  """

  def get_original(_path) do
    # FIXME if original -> original, or download_original -> original
  end

  def check_file(_path) do
    # TODO
  end

  def download_original(url) do
    original_path = Application.fetch_env!(:media_p, :original_path)
    {:ok, response} = Req.get(url)

    file_name = url |> String.split("/") |> List.last()

    image =
      Image.open!(response.body)
      |> Image.write("#{original_path}/#{file_name}")

    {:ok, image, file_name}
  end
end
