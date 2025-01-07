defmodule MediaP.FileHandler do
  @moduledoc """
  Helps working with media files
  """
  require Logger

  @original_path Application.compile_env!(:media_p, :original_path)
  @origin Application.compile_env!(:media_p, :origin)
  @transformed_path Application.compile_env!(:media_p, :transformed_path)
  @options Application.compile_env!(:media_p, :req_options)

  @doc """
  Returns media by given transformed path
  """
  def get_original(file_path) do
    file_name = String.split(file_path, "/") |> List.last()
    path = "#{@original_path}/#{file_name}"

    case File.exists?(path) do
      true ->
        Logger.info("Image exists: #{path}")
        {:ok, path: path}

      false ->
        Logger.info("Image doesn't exists: #{path}")
        download_original(file_path)
    end
  end

  # Downloads original media and writes it to the original path
  defp download_original(url) do
    url = "https://#{@origin}#{url}"
    {:ok, response} = Req.get(url, @options)

    file_name = url |> String.split("/") |> List.last()
    save_path = "#{@original_path}/#{file_name}"

    {:ok, _} =
      Image.open!(response.body)
      |> Image.write(save_path)

    {:ok, path: save_path}
  end

  @doc """
  Returns media by given transformed path
  """
  def get_transformed(flags, file_path, mode) do
    file_name = String.split(file_path, "/") |> List.last()
    flags_path = map_flags_to_path(flags)
    path = "#{@transformed_path}/#{flags_path}/#{file_name}"

    case File.exists?(path) do
      true ->
        {:ok, path: path}

      false ->
        transformation_pipeline(flags, file_path, mode)
    end
  end

  defp transformation_pipeline(flags, file_path, :proxy) do
    download_transformed(flags, file_path)
  end

  defp transformation_pipeline(flags, file_path, :in_place) do
    # TODO: make transformation in place
    download_transformed(flags, file_path)
  end

  # Downloads transformed media and writes it to the file system according to the flags
  defp download_transformed(flags, url) do
    flags_path = map_flags_to_path(flags)
    dir_path = "#{@transformed_path}/#{flags_path}/"

    url = "https://#{@origin}/#{Enum.join(flags, ",")}/#{url}"
    {:ok, response} = Req.get(url, @options)

    file_name = url |> String.split("/") |> List.last()

    File.mkdir_p!(Path.dirname(dir_path))
    save_path = "#{dir_path}#{file_name}"

    {:ok, _} =
      Image.open!(response.body)
      |> Image.write(save_path)

    {:ok, path: save_path}
  end

  defp map_flags_to_path(flags), do: Enum.join(flags, "/")
end
