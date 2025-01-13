defmodule MediaP.FilePath do
  @enforce_keys [:system_path, :filename, :extension, :dir_name]

  defstruct [:system_path, :filename, :extension, :dir_name]
end
