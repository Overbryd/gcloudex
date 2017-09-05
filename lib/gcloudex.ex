defmodule GCloudex do

  @moduledoc """
  Set of wrappers for Google Cloud Platform's services API's.
  """

  @doc """
  Returns the Google Project ID specified in the creds.json file in the configs.
  """
  @spec get_project_id :: binary
  def get_project_id do
    {:ok, <<_,_::binary>> = project_id} = Goth.Config.get(:project_id)
    project_id
  end
end
