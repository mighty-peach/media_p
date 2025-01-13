defmodule MediaP.Server do
  import Plug.Conn

  alias MediaP.MediaPipeline

  @mode Application.compile_env!(:media_p, :mode)

  # TODO: add :in_place mode

  def init(options) do
    options
  end

  def call(conn, _opts) do
    request_path = conn.request_path

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

    conn
    |> put_resp_content_type("#{media.type}/#{file_path.extension}")
    |> send_file(200, file_path.system_path)
  end
end
