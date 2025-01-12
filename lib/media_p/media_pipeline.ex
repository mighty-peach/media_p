defmodule MediaP.MediaPipeline do
  @moduledoc false

  @doc """
  handles media based on specified param in url

  arg request_path: String, `/path/to/file`
  arg mode: :proxy | :in_place
  """

  def handle(request_path, mode) do
    MediaP.ImagePipeline.handle(request_path, mode)
  end
end
