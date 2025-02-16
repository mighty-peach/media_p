defmodule MediaP.FilePath do
  @enforce_keys [:system_path, :system_original_path, :filename, :extension, :dir_name]

  defstruct [
    :system_path,
    :filename,
    :extension,
    :original_path,
    :system_original_path,
    :dir_name
  ]
end
