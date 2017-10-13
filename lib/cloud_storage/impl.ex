defmodule GCloudex.CloudStorage.Impl do

  @moduledoc """
  Wrapper for Google Cloud Storage API.
  """
  defmacro __using__(:cloud_storage) do 
    quote do 
      use GCloudex.CloudStorage.Request

      @endpoint "storage.googleapis.com"
      @project  GCloudex.get_project_id

      ###################
      ### GET Service ###
      ###################

      @doc"""
      Lists all the buckets in the specified project.
      """
      @spec list_buckets() :: HTTPResponse.t
      def list_buckets do
        request_service
      end

      #####################
      ### DELETE Bucket ###
      #####################

      @doc"""
      Deletes and empty bucket.
      """
      @spec delete_bucket(bucket :: binary) :: HTTPResponse.t
      def delete_bucket(bucket) do
        request :delete, bucket, [], ""
      end

      ##################
      ### GET Bucket ###
      ##################

      @doc"""
      Lists all the objects in the specified 'bucket'.
      """
      @spec list_objects(bucket :: binary) :: HTTPResponse.t
      def list_objects(bucket) do
        request :get, bucket, [], ""
      end

      @doc"""
      Lists all the objects in the specified 'bucket' using the
      given 'query_params'. The query parameters must be passed as a list of tuples
      [{param_1, value_1}, {param_2, value_2}].
      """
      @spec list_objects(bucket :: binary, query_params :: [{binary, binary}]) :: HTTPResponse.t
      def list_objects(bucket, query_params) do
        request_query :get, bucket, [], "",
          "?" <> parse_query_params(query_params, "")
      end

      @doc"""
      Lists the specified 'bucket' ACL.
      """
      @spec get_bucket_acl(bucket :: binary) :: HTTPResponse.t
      def get_bucket_acl(bucket) do
        request_query :get, bucket, [], "", "?acl"
      end

      @doc"""
      Lists the specified 'bucket' CORS configuration.
      """
      @spec get_bucket_cors(bucket :: binary) :: HTTPResponse.t
      def get_bucket_cors(bucket) do
        request_query :get, bucket, [], "", "?cors"
      end

      @doc"""
      Lists the specified 'bucket' lifecycle configuration.
      """
      @spec get_bucket_lifecycle(bucket :: binary) :: HTTPResponse.t
      def get_bucket_lifecycle(bucket) do
        request_query :get, bucket, [], "", "?lifecycle"
      end

      @doc"""
      Lists the specified 'bucket' location.
      """
      @spec get_bucket_region(bucket :: binary) :: HTTPResponse.t
      def get_bucket_region(bucket) do
        request_query :get, bucket, [], "", "?location"
      end

      @doc"""
      Lists the specified 'bucket' logging configuration.
      """
      @spec get_bucket_logging(bucket :: binary) :: HTTPResponse.t
      def get_bucket_logging(bucket) do
        request_query :get, bucket, [], "", "?logging"
      end

      @doc"""
      Lists the specified 'bucket' class.
      """
      @spec get_bucket_class(bucket :: binary) :: HTTPResponse.t
      def get_bucket_class(bucket) do
        request_query :get, bucket, [], "", "?storageClass"
      end

      @doc"""
      Lists the specified 'bucket' versioning configuration.
      """
      @spec get_bucket_versioning(bucket :: binary) :: HTTPResponse.t
      def get_bucket_versioning(bucket) do
        request_query :get, bucket, [], "", "?versioning"
      end

      @doc"""
      Lists the specified 'bucket' website configuration.
      """
      @spec get_bucket_website(bucket :: binary) :: HTTPResponse.t
      def get_bucket_website(bucket) do
        request_query :get, bucket, [], "", "?website"
      end

      ###################
      ### HEAD Bucket ###
      ###################

      @doc"""
      Indicates if the specified 'bucket' exists or whether the request has READ
      access to it.
      """
      @spec exists_bucket(bucket :: binary) :: HTTPResponse.t
      def exists_bucket(bucket) do
        request :head, bucket, [], ""
      end

      ##################
      ### PUT Bucket ###
      ##################

      @doc"""
      Creates a bucket with the specified 'bucket' name if available. This
      function will create the bucket in the default region 'US' and with
      the default class 'STANDARD'.
      """
      @spec create_bucket(bucket :: binary) :: HTTPResponse.t
      def create_bucket(bucket) do
        headers = [{"x-goog-project-id", @project}]

        request :put, bucket, headers, ""
      end

      @doc"""
      Creates a bucket with the specified 'bucket' name if available and in
      the specified 'region'. This function will create the bucket with the
      default class 'STANDARD'.
      """
      @spec create_bucket(bucket :: binary, region :: binary) :: HTTPResponse.t
      def create_bucket(bucket, region) do
        headers = [{"x-goog-project-id", @project}]
        body    =
          """
          <CreateBucketConfiguration>
            <LocationConstraint>#{region}</LocationConstraint>
          </CreateBucketConfiguration>
          """

        request :put, bucket, headers, body
      end

      @doc"""
      Creates a bucket with the specified 'bucket' name if available and in
      the specified 'region' and with the specified 'class'.
      """
      @spec create_bucket(bucket :: binary, region :: binary, class :: binary) :: HTTPResponse.t
      def create_bucket(bucket, region, class) do
        headers = [{"x-goog-project-id", @project}]

        body =
          """
          <CreateBucketConfiguration>
            <LocationConstraint>#{region}</LocationConstraint>
            <StorageClass>#{class}</StorageClass>
          </CreateBucketConfiguration>
          """
        request :put, bucket, headers, body
      end

      @doc"""
      Sets or modifies the existing ACL in the specified 'bucket'
      with the given 'acl_config' in XML format.
      """
      @spec set_bucket_acl(bucket :: binary, acl_config :: binary) :: HTTPResponse.t
      def set_bucket_acl(bucket, acl_config) do
        request_query :put, bucket, [], acl_config, "?acl"
      end

      @doc"""
      Sets or modifies the existing CORS configuration in the specified 'bucket'
      with the given 'cors_config' in XML format.
      """
      @spec set_bucket_cors(bucket :: binary, cors_config :: binary) :: HTTPResponse.t
      def set_bucket_cors(bucket, cors_config) do
        request_query :put, bucket, [], cors_config, "?cors"
      end

      @doc"""
      Sets or modifies the existing lifecyle configuration in the specified
      'bucket' with the given 'lifecycle_config' in XML format.
      """
      @spec set_bucket_lifecycle(bucket :: binary, lifecycle_config :: binary) :: HTTPResponse.t
      def set_bucket_lifecycle(bucket, lifecycle_config) do
        request_query :put, bucket, [], lifecycle_config, "?lifecycle"
      end

      @doc"""
      Sets or modifies the existing logging configuration in the specified
      'bucket' with the given 'logging_config' in XML format.
      """
      @spec set_bucket_logging(bucket :: binary, logging_config :: binary) :: HTTPResponse.t
      def set_bucket_logging(bucket, logging_config) do
        request_query :put, bucket, [], logging_config, "?logging"
      end

      @doc"""
      Sets or modifies the existing versioning configuration in the specified
      'bucket' with the given 'versioning_config' in XML format.
      """
      @spec set_bucket_versioning(bucket :: binary, versioning_config :: binary) :: HTTPResponse.t
      def set_bucket_versioning(bucket, versioning_config) do
        request_query :put, bucket, [], versioning_config, "?versioning"
      end

      @doc"""
      Sets or modifies the existing website configuration in the specified
      'bucket' with the given 'website_config' in XML format.
      """
      @spec set_bucket_website(bucket :: binary, website_config :: binary) :: HTTPResponse.t
      def set_bucket_website(bucket, website_config) do
        request_query :put, bucket, [], website_config, "?websiteConfig"
      end

      #####################
      ### DELETE Object ###
      #####################

      @doc"""
      Deletes the 'object' in the specified 'bucket'.
      """
      @spec delete_object(bucket :: binary, object :: binary) :: HTTPResponse.t
      def delete_object(bucket, object) do
        request_query :delete, bucket, [], "", object
      end

      @doc"""
      Deletes the 'object' in the specified 'bucket' using the
      given 'query_params'. The query parameters must be passed as a list of tuples
      [{param_1, value_1}, {param_2, value_2}].
      """
      @spec delete_object(bucket :: binary, object :: binary, query_params :: [{binary, binary}]) :: HTTPResponse.t
      def delete_object(bucket, object, query_params) do
        request_query :delete, bucket, [], "",
          object <> "?" <> parse_query_params(query_params, "")
      end

      ##################
      ### GET Object ###
      ##################

      @doc"""
      Downloads the 'object' from the specified 'bucket'. The requester must have
      READ permission.
      """
      @spec get_object(bucket :: binary, object :: binary) :: HTTPResponse.t
      def get_object(bucket, object) do
        request_query :get, bucket, [], "", object
      end

      @doc"""
      Downloads the 'object' from the specified 'bucket' using the given
      'query_params'. The query parameters must be passed as a list of tuples
      [{param_1, value_1}, {param_2, value_2}]. The requester must have READ
      permission.
      """
      @spec get_object(bucket :: binary, object :: binary, query_params :: [{binary, binary}]) :: HTTPResponse.t
      def get_object(bucket, object, query_params) do
        request_query :get, bucket, [], "",
          object <> "?" <> parse_query_params(query_params, "")
      end

      @doc"""
      Lists the 'object' ACL from the specified 'bucket'. The requester must have
      FULL_CONTROL permission.
      """
      @spec get_object_acl(bucket :: binary, object :: binary) :: HTTPResponse.t
      def get_object_acl(bucket, object) do
        request_query :get, bucket, [], "", object <> "?acl"
      end

      ###################
      ### HEAD Object ###
      ###################

      @doc"""
      Lists metadata for the given 'object' from the specified 'bucket'.
      """
      @spec get_object_metadata(bucket :: binary, object :: binary) :: HTTPResponse.t
      def get_object_metadata(bucket, object) do
        request_query :head, bucket, [], "", object
      end

      @doc"""
      Lists metadata for the given 'object' from the specified 'bucket' using the
      given 'query_params'. The query parameters must be passed as a list of tuples
      [{param_1, value_1}, {param_2, value_2}].
      """
      @spec get_object_metadata(bucket :: binary, object :: binary, [{binary, binary}]) :: HTTPResponse.t
      def get_object_metadata(bucket, object, query_params) do
        request_query :head, bucket, [], "", object <> "?" <> parse_query_params(query_params, "")
      end

      ##################
      ### PUT Object ###
      ##################

      @doc"""
      Uploads the file in the given 'filepath' to the specified 'bucket'.
      If a 'bucket_path' is specified then the filename must be included at
      the end:

        put_object "somebucket",
                   "/home/user/Documents/this_file",
                   "new_folder/some_other_folder/this_file"

        => # This will upload the file to the directory in 'bucket_path' and
             will create the directories if they do not exist.
      """
      @spec put_object(bucket :: binary, filepath :: binary, bucket_path :: binary) :: HTTPResponse.t
      def put_object(bucket, filepath, bucket_path \\ :empty) do
        body = {:file, filepath}

        case bucket_path do
          :empty -> request_query :put, bucket, [], body, filepath
          _      -> request_query :put, bucket, [], body, bucket_path
        end
      end

      @doc"""
      Copies the specified 'source_object' into the given 'new_bucket' as
      'new_object'.
      """
      @spec copy_object(new_bucket :: binary, new_object :: binary, source_object :: binary) :: HTTPResponse.t
      def copy_object(new_bucket, new_object, source_object) do
        headers = [{"x-goog-copy-source", source_object}]
        request_query :put, new_bucket, headers, new_object
      end

      @doc"""
      Sets or modifies the 'object' from the specified 'bucket' with the provided
      'acl_config' in XML format.
      """
      @spec set_object_acl(bucket :: binary, object :: binary, acl_config :: binary) :: HTTPResponse.t
      def set_object_acl(bucket, object, acl_config) do
        request_query :put, bucket, [], acl_config, object <> "?acl"
      end

      @doc"""
      Sets or modifies the 'object' from the specified 'bucket' with the provided
      'acl_config' in XML format and using the given 'query_params'. The query
      parameters must be passed as a list of tuples
      [{param_1, value_1}, {param_2, value_2}].
      """
      @spec set_object_acl(bucket :: binary, object :: binary, acl_config :: binary, [{binary, binary}]) :: HTTPResponse.t
      def set_object_acl(bucket, object, acl_config, query_params) do
        request_query :put, bucket, [], acl_config,
          object <> "?acl" <> "&" <> parse_query_params(query_params, "")
      end

      ########################
      ### HELPER FUNCTIONS ###
      ########################

      defp parse_query_params([], query), do: query <> ""
      defp parse_query_params([{param, val} = _head | []], query), do: query <> param <> "=" <> val
      defp parse_query_params([{param, val} = _head | tail], query) do
        parse_query_params tail, query <> param <> "=" <> val <> "&"
      end     
    end
  end  
end