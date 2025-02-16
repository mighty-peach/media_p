defmodule MediaP.Path do
  @moduledoc false
  alias MediaP.FilePath

  def get_file_path(request_path, flags, system_dir) do
    filename = get_filename(request_path)
    extenstion = get_extension(request_path)
    system_path = get_system_path(filename, flags, system_dir)
    dir_name = get_dir_to_file(system_path, filename)

    %FilePath{
      filename: filename,
      extension: extenstion,
      system_path: system_path,
      system_original_path: system_path,
      dir_name: dir_name
    }
  end

  def get_file_path(request_path, flags, system_dir, segments_before_flags) do
    filename = get_filename(request_path)
    extenstion = get_extension(request_path)
    system_path = get_system_path(filename, flags, system_dir)
    system_original_path = get_system_path(filename, [], system_dir)
    dir_name = get_dir_to_file(system_path, filename)
    original_path = get_path_to_original(request_path, segments_before_flags)

    %FilePath{
      filename: filename,
      extension: extenstion,
      system_path: system_path,
      system_original_path: system_original_path,
      dir_name: dir_name,
      original_path: original_path
    }
  end

  def get_path_to_original(request_path, segments_before_flags) do
    request_path
    |> String.split("/")
    |> List.delete_at(segments_before_flags + 1)
    |> Enum.join("/")
  end

  @doc """
  Returns extension of gived file

  arg request_path: String, "/test/media/test.jpg"

  returns "jpg"
  """
  def get_extension(request_path) do
    request_path
    |> String.split("/")
    |> List.last()
    |> String.split(".")
    |> List.last()
  end

  @doc """
  Returns filename of gived file

  arg request_path: String, "/test/media/test.jpg"

  returns "test.jpg"
  """
  def get_filename(request_path) do
    request_path
    |> String.split("/")
    |> List.last()
  end

  def get_system_path(filename, flags, system_dir) do
    case length(flags) == 0 do
      true ->
        "#{system_dir.original}/#{filename}"

      false ->
        flags_as_path = map_flags_to_path(flags)
        "#{system_dir.transformed}/#{flags_as_path}/#{filename}"
    end
  end

  defp map_flags_to_path(flags),
    do: flags |> Enum.join("/")

  @doc """
  Returns URL for downloading media

  arg origin: String, "media.com"
  arg request_path: String, "/test/media/test.jpg"

  returns "https://media.com/test/media/test.jpg"
  """
  def get_download_url(origin, request_path), do: "https://#{origin}#{request_path}"

  @doc """
  Returns dir path for provided file path

  arg system_path: String, "/test/original/test.jpg"

  returns "/test/original"
  """
  def get_dir_to_file(system_path, filename) do
    String.replace_trailing(system_path, "#{filename}", "")
  end
end
