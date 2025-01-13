defmodule MediaP.ImagePipeline do
  @moduledoc false

  alias MediaP.Media
  alias MediaP.Flags

  @origin Application.compile_env!(:media_p, :origin)
  @segments_before_flags Application.compile_env!(:media_p, :segments_before_flags)
  @systed_dir %{
    original: Application.compile_env!(:media_p, :original_path),
    transformed: Application.compile_env!(:media_p, :transformed_path)
  }

  def get_file_path(request_path) do
    flags = Flags.parse(request_path, @segments_before_flags)

    MediaP.Path.get_file_path(request_path, flags, @systed_dir)
  end

  def wrap_cached(file) do
    %Media{
      file: file,
      type: "image"
    }
  end

  def get_new(request_path, :proxy) do
    download_url = MediaP.Path.get_download_url(@origin, request_path)

    image = MediaP.Source.download_image(download_url)

    %MediaP.Media{
      file: image,
      type: "image"
    }
  end
end
