defmodule MediaP.Path do
  @moduledoc false

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

  @doc """
  Returns path for the giver filename according to config and flags value

  arg filename: String, "test.jpg"
  arg flags: List, [w: 10]
  arg config: %{ transformed: String, original: String }

  returns "/assets/transformed/w_10/test.jpg"
  """
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
    do: flags |> Enum.map(fn x -> "#{elem(x, 0)}_#{elem(x, 1)}" end) |> Enum.join("/")

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
