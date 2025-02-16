defmodule MediaP.Server do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    request_path = conn.request_path

    task = Task.async(fn -> MediaP.Handler.handle(request_path) end)
    {:ok, response} = Task.await(task)

    conn
    |> put_resp_content_type(response.content_type)
    |> send_file(200, response.file_path)
  end
end
