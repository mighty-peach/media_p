defmodule MediaP.Server do
  import Plug.Conn

  alias MediaP.FileHandler
  alias MediaP.Parser

  # TODO: add a way to define parts of url before flags
  # TODO: think about extenstions

  require Logger

  def init(options) do
    options
  end

  def call(conn, _opts) do
    request_path = conn.request_path

    extension =
      conn.path_info
      |> List.last()
      |> String.split(".")
      |> List.last()

    {:ok, path: path} =
      case Parser.parse(request_path) do
        [] -> FileHandler.get_original(request_path)
        flags -> FileHandler.get_transformed(flags, request_path, :proxy)
      end

    conn
    |> put_resp_content_type("image/#{extension}")
    |> send_file(200, path)
  end
end
