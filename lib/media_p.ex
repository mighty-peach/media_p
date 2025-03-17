defmodule MediaP do
  use Application
  require Logger

  @impl true
  def start(_start_type, _start_args) do
    MediaP.Setup.ensure_directories_exist()

    children = [
      {Bandit, plug: MediaP.Server, port: Application.get_env(:media_p, :port)}
    ]

    opts = [strategy: :one_for_one, name: MediaP.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
