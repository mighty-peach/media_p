defmodule MediaP do
  use Application

  def start(_start_type, _start_args) do
    # TODO: start server
    # TODO: run in proxy pipeline
    # TODO: add in place transformations
    # TODO: run in place pipeline
    {:ok, self()}
  end
end
