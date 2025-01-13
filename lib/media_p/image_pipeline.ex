defmodule MediaP.ImagePipeline do
  @moduledoc false

  alias MediaP.Media
  alias MediaP.Flags

  @origin Application.compile_env!(:media_p, :origin)
  @known_flags Application.compile_env!(:media_p, :known_flags)
  @segments_before_flags Application.compile_env!(:media_p, :segments_before_flags)
  @systed_dir %{
    original: Application.compile_env!(:media_p, :original_path),
    transformed: Application.compile_env!(:media_p, :transformed_path)
  }

  # TODO: fix test for Path.get_system_path
  def get_system_path(request_path) do
    flags = Flags.parse(request_path, @known_flags, @segments_before_flags)

    MediaP.Path.get_system_path(request_path, flags, @systed_dir)
  end

  def wrap_cached(file, system_path) do
    %Media{
      file: file,
      extension: MediaP.Path.get_extension(system_path),
      type: "image",
      path: system_path
    }
  end

  def get_new(system_path, request_path, :proxy) do
    filename = MediaP.Path.get_filename(request_path)
    dir_path = MediaP.Path.get_dir_to_file(system_path, filename)
    download_url = MediaP.Path.get_download_url(@origin, request_path)
    image = MediaP.Source.download_image(download_url)
    extension = MediaP.Path.get_extension(system_path)

    %{
      dir_path: dir_path,
      media: %MediaP.Media{
        file: image,
        extension: extension,
        path: system_path,
        type: "image"
      }
    }
  end

  # def handle(request_path, mode) do
  #   flags = Flags.parse(request_path, @known_flags, @segments_before_flags)
  #   extension = MediaP.Path.get_extension(request_path)
  #   filename = MediaP.Path.get_filename(request_path)
  #   system_path = MediaP.Path.get_system_path(filename, flags, @systed_dir)
  #
  #   file =
  #     case File.exists?(system_path) do
  #       true ->
  #         File.open!(system_path)
  #
  #       false ->
  #         dir_path = MediaP.Path.get_dir_to_file(system_path, filename)
  #
  #         transformation_flow(mode, dir_path, request_path, system_path)
  #     end
  #
  #   %MediaP.Media{
  #     file: file,
  #     extension: extension,
  #     path: system_path,
  #     type: "image"
  #   }
  # end
  #
  # defp transformation_flow(:proxy, dir_path, request_path, system_path) do
  #   download_url = MediaP.Path.get_download_url(@origin, request_path)
  #   image = MediaP.Source.download_image(download_url)
  #
  #   File.mkdir_p!(Path.dirname(dir_path))
  #   File.write!(system_path, image)
  #
  #   image
  # end
end
