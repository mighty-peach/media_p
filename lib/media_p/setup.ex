defmodule MediaP.Setup do
  @moduledoc """
  Handles setup tasks for MediaP such as ensuring required directories exist
  """
  require Logger

  def ensure_directories_exist do
    [
      Application.get_env(:media_p, :transformed_path),
      Application.get_env(:media_p, :original_path),
      Application.get_env(:media_p, :test_path, nil)
    ]
    |> Enum.filter(&is_binary/1)
    |> Enum.each(&make_directory/1)
  end

  defp make_directory(path) do
    case File.mkdir_p(path) do
      :ok ->
        :ok

      {:error, reason} ->
        Logger.warning("Failed to create directory #{path}: #{inspect(reason)}")
    end
  end
end
