defmodule MediaP.Flags do
  @moduledoc false

  @doc """
  returns list of tuples with flags

  arg request_path: String, "/media/url/w_10,h_20/file.jpg"
  arg segments_before_flags: Integer, 2

  return [w_10, h_20]
  """
  def parse(request_path, segments_before_flags \\ 0) when is_binary(request_path) do
    request_path
    |> get_flags(segments_before_flags)
    |> Enum.sort(:desc)
  end

  defp get_flags(path, segments_before_flags) do
    splitted = String.split(path, "/") |> Enum.filter(fn x -> String.length(x) !== 0 end)

    if length(splitted) > segments_before_flags + 1 do
      segment = Enum.at(splitted, segments_before_flags)

      if contains_flags?(segment) do
        segment
        |> String.split(",")
      else
        []
      end
    else
      []
    end
  end

  defp contains_flags?(segment) do
    String.split(segment, ",") |> Enum.all?(fn x -> String.contains?(x, "_") end)
  end
end
