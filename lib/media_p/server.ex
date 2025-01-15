defmodule MediaP.Server do
  import Plug.Conn

  # TODO: add :in_place mode

  def init(options) do
    options
  end

  def call(conn, _opts) do
    request_path = conn.request_path

    current = self()
    spawn(fn -> MediaP.Handler.handle(current, request_path) end)

    response =
      receive do
        {:ok, response} -> response
      end

    conn
    |> put_resp_content_type(response.content_type)
    |> send_file(200, response.file_path)
  end
end
