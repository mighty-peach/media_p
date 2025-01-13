defmodule MediaP.Server do
  import Plug.Conn

  alias MediaP.MediaPipeline

  @mode Application.compile_env!(:media_p, :mode)

  # TODO: add :in_place mode
  # TODO: Flags -> add procedures to work with flags values
  # TODO: Flags -> b flags contains additional _,
  # so flags pipeline will broke, need to go through all the tuple elements and join them with _
  #
  # TODO: add type guards or `when` to functions

  def init(options) do
    options
  end

  def call(conn, _opts) do
    request_path = conn.request_path

    system_path = MediaPipeline.get_system_path(request_path)

    media =
      if File.exists?(system_path) do
        file = File.open!(system_path)
        MediaPipeline.handle_from_cache(file, system_path)
      else
        %{dir_path: dir_path, media: media} =
          MediaPipeline.handle_new(system_path, request_path, @mode)

        File.mkdir_p!(Path.dirname(dir_path))
        File.write!(system_path, media.file)

        media
      end

    conn
    |> put_resp_content_type("#{media.type}/#{media.extension}")
    |> send_file(200, media.path)
  end
end
