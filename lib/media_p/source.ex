defmodule MediaP.Source do
  @moduledoc false

  @req_options Application.compile_env!(:media_p, :req_options)

  @doc """
  Downloads image by given path

  arg url: String, "https://media.com/test.jpg"
  arg options: List, # this one is for tests

  returns binary image
  """
  def download_image(url, options \\ @req_options) do
    {:ok, response} = Req.get(url, options)

    response.body
  end
end
