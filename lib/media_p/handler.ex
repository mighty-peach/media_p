defmodule MediaP.Handler do
  alias MediaP.MediaPipeline

  @mode Application.compile_env!(:media_p, :mode)

  def handle(parent, request_path) do
    file_path = MediaPipeline.get_file_path(request_path)

    media =
      if File.exists?(file_path.system_path) do
        file = File.open!(file_path.system_path)
        MediaPipeline.handle_from_cache(file)
      else
        media =
          MediaPipeline.handle_new(request_path, @mode)

        File.mkdir_p!(Path.dirname(file_path.dir_name))
        File.write!(file_path.system_path, media.file)

        media
      end

    send(
      parent,
      {:ok,
       %{content_type: "#{media.type}/#{file_path.extension}", file_path: file_path.system_path}}
    )
  end
end
