defmodule MediaP.Server do
  import Plug.Conn

  alias MediaP.Media
  alias MediaP.MediaPipeline

  @mode Application.compile_env!(:media_p, :mode)

  # TODO: add :in_place mode
  # TODO: Flags -> add procedures to work with flags values
  # TODO: Flags -> b flags contains additional _, so flags pipeline will broke, need to go through all the tuple elements and join them with _

  def init(options) do
    options
  end

  def call(conn, _opts) do
    request_path = conn.request_path

    media = %Media{} = MediaPipeline.handle(request_path, @mode)

    conn
    |> put_resp_content_type("#{media.type}/#{media.extension}")
    |> send_file(200, media.path)
  end
end
