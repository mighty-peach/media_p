defmodule MediaP.Media do
  @enforce_keys [:extension, :type, :file, :path]

  defstruct [:extension, :file, :type, :path]
end
