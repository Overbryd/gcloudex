defmodule GCloudex.Auth do
  alias Goth.Token, as: GoogleAuth

  @moduledoc """
  Provides retrieval of authentication tokens for several Google Cloud Platform
  services' scopes.
  """

  # General Cloud Platform Scopes
  @cloud_scope_cs_read_only   "https://www.googleapis.com/auth/cloud-platform.read-only"
  @cloud_scope_cs             "https://www.googleapis.com/auth/cloud-platform"

  # Cloud Storage scopes
  @storage_scope_read_only    "https://www.googleapis.com/auth/devstorage.read_only"
  @storage_scope_read_write   "https://www.googleapis.com/auth/devstorage.read_write"
  @storage_scope_full_control "https://www.googleapis.com/auth/devstorage.full_control"

  # Cloud SQL scopes
  @sql_scope_admin            "https://www.googleapis.com/auth/sqlservice.admin"

  # Compute Engine scopes
  @compute_read_only          "https://www.googleapis.com/auth/compute.readonly"
  @compute                    "https://www.googleapis.com/auth/compute"

  @doc """
  Retrieves an authentication token for the Google Cloud Storage service.
  """
  @spec get_token_storage(atom) :: binary
  def get_token_storage(type) do
    scope =
      case type do
        :read_only -> @storage_scope_read_only
        :read_write -> @storage_scope_read_write
        :full_control -> @storage_scope_full_control
        :sql_admin -> @sql_scope_admin
        :cs_read_only -> @cloud_scope_cs_read_only
        :cs -> @cloud_scope_cs
        :compute_read_only -> @compute_read_only
        :compute -> @compute
      end

    {:ok, get_token_response} = GoogleAuth.for_scope scope
    Map.get(get_token_response, :token)
  end
end
