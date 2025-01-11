defmodule MediaP.Parser do
  @moduledoc """
  Helps working with media url
  """
  @path_before_flags Application.compile_env!(:media_p, :path_before_flags)
  @known_flags Application.compile_env!(:media_p, :known_flags)

  @doc """
  Returns map with tranformation, filtered and sorted alphabetically flags

  Returns `[flag: value]`
  """
  def parse(url) do
    url
    |> get_flags()
    |> filter_flags()
    |> transform_flags()
    |> Enum.sort(:desc)
  end

  defp get_flags(url) do
    url =
      if String.length(@path_before_flags) > 0 and
           String.starts_with?(url, "/#{@path_before_flags}") do
        String.replace(url, "/#{@path_before_flags}", "")
      else
        url
      end

    url
    |> String.split("/")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(fn x ->
      x |> String.split("_") |> List.to_tuple()
    end)
  end

  defp filter_flags(flags) do
    Enum.filter(flags, fn flag ->
      not is_nil(Enum.find(@known_flags, nil, fn x -> elem(flag, 0) == x end))
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
