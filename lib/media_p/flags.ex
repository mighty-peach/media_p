defmodule MediaP.Flags do
  @moduledoc false

  @known_flags ["w", "h", "c", "dpr", "f", "b", "q"]
  @doc """
  returns list of tuples with flags

  arg request_path: String, "/media/url/w_10,h_20/file.jpg"
  arg segments_before_flags: Integer, 2
  arg known_flags: List,  ["w", "h"]

  return [w: 10, h: 10]
  """
  def parse(request_path, segments_before_flags \\ 0) when is_binary(request_path) do
    request_path
    |> get_flags(segments_before_flags)
    |> filter_flags(@known_flags)
    |> transform_flags()
    |> Enum.sort(:desc)
  end

  defp get_flags(path, segments_before_flags) do
    path
    |> String.split("/")
    |> Enum.at(segments_before_flags + 1)
    |> String.split(",")
    |> Enum.map(fn x ->
      x |> String.split("_") |> List.to_tuple()
    end)
  end

  defp filter_flags(flags, known_flags) do
    Enum.filter(flags, fn flag ->
      not is_nil(Enum.find(known_flags, nil, fn x -> elem(flag, 0) == x end))
    end)
  end

  defp transform_flags(flags) when length(flags) == 0 do
    []
  end

  defp transform_flags([head | tail]) do
    get_flag(elem(head, 0), [head | tail], [])
  end

  defp get_flag("w", [head | tail], result) do
    result = [{:w, String.to_integer(elem(head, 1))} | result]
    next = get_next_flag(tail)

    get_flag(next, tail, result)
  end

  defp get_flag("h", [head | tail], result) do
    result = [{:h, String.to_integer(elem(head, 1))} | result]
    next = get_next_flag(tail)

    get_flag(next, tail, result)
  end

  defp get_flag("c", [head | tail], result) do
    result = [{:c, elem(head, 1)} | result]
    next = get_next_flag(tail)

    get_flag(next, tail, result)
  end

  defp get_flag("dpr", [head | tail], result) do
    result = [{:drp, String.to_float(elem(head, 1))} | result]
    next = get_next_flag(tail)

    get_flag(next, tail, result)
  end

  defp get_flag("f", [head | tail], result) do
    result = [{:f, elem(head, 1)} | result]
    next = get_next_flag(tail)

    get_flag(next, tail, result)
  end

  defp get_flag("q", [head | tail], result) do
    result = [{:q, elem(head, 1)} | result]
    next = get_next_flag(tail)

    get_flag(next, tail, result)
  end

  defp get_flag("b", [head | tail], result) do
    result = [
      {:b,
       head
       |> Tuple.delete_at(0)
       |> Tuple.to_list()
       |> Enum.join("_")}
      | result
    ]

    next = get_next_flag(tail)

    get_flag(next, tail, result)
  end

  defp get_flag(nil, _rest, result) do
    result
  end

  defp get_next_flag([]) do
    nil
  end

  defp get_next_flag(flags) do
    flags
    |> List.first()
    |> elem(0)
  end
end
