defmodule MediaP.MediaPipeline do
  @moduledoc false

  alias MediaP.ImagePipeline

  def get_system_path(request_path) do
    ImagePipeline.get_system_path(request_path)
  end

  def handle_from_cache(file, system_path) do
    ImagePipeline.wrap_cached(file, system_path)
  end

  def handle_new(system_path, request_path, mode) do
    ImagePipeline.get_new(system_path, request_path, mode)
  end
end
