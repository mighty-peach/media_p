defmodule MediaP.MediaPipeline do
  @moduledoc false

  alias MediaP.ImagePipeline

  def get_file_path(request_path) do
    ImagePipeline.get_file_path(request_path)
  end

  def handle_from_cache(file) do
    ImagePipeline.wrap_cached(file)
  end

  def handle_downloaded(request_path) do
    ImagePipeline.get_new(request_path)
  end
end
