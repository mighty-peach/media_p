defmodule MediaP.ImagePipeline do
  @moduledoc false

  alias MediaP.Flags

  @origin Application.compile_env!(:media_p, :origin)
  @known_flags Application.compile_env!(:media_p, :known_flags)
  @segments_before_flags Application.compile_env!(:media_p, :segments_before_flags)
  @systed_dir %{
    original: Application.compile_env!(:media_p, :original_path),
    transformed: Application.compile_env!(:media_p, :transformed_path)
  }

  def handle(request_path, mode) do
    flags = Flags.parse(request_path, @known_flags, @segments_before_flags)
    extension = MediaP.Path.get_extension(request_path)
    filename = MediaP.Path.get_filename(request_path)
    system_path = MediaP.Path.get_system_path(filename, flags, @systed_dir)

    file =
      case File.exists?(system_path) do
        true ->
          File.open!(system_path)

        false ->
          dir_path = MediaP.Path.get_dir_to_file(system_path, filename)

          transformation_flow(mode, dir_path, request_path, system_path)
      end

    %MediaP.Media{
      file: file,
      extension: extension,
      path: system_path,
      type: "image"
    }
  end

  defp transformation_flow(:proxy, dir_path, request_path, system_path) do
    download_url = MediaP.Path.get_download_url(@origin, request_path)
    image = MediaP.Source.download_image(download_url)

    File.mkdir_p!(Path.dirname(dir_path))
    File.write!(system_path, image)

    image
  end
end
