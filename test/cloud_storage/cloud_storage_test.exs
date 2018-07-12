defmodule Test.Dummy.CloudStorage do
  use ExUnit.Case
  use GCloudex.CloudStorage.Impl, :cloud_storage

  @endpoint "storage.googleapis.com"

  def request_service do
    %{
      verb: :get,
      host: @endpoint,
      body: "",
      headers:
        [
          {"x-goog-project-id", GCloudex.get_project_id()},
          {"Authorization", "Bearer Dummy Token"}
        ],
      opts: []
    }
  end

  def request(verb, bucket, headers \\ [], body \\ "") do
    %{
      verb: verb,
      host: bucket <> "." <> @endpoint,
      body: body,
      headers:
        headers ++
        [
          {"Authorization", "Bearer Dummy Token"}
        ],
      opts: []
    }
  end

  def request_query(verb, bucket, headers \\ [], body \\ "", parameters) do
    %{
      verb: verb,
      host: bucket <> "." <> @endpoint <> "/" <> parameters,
      body: body,
      headers:
        headers ++
        [
          {"Authorization", "Bearer Dummy Token"}
        ],
      opts: []
    }
  end
end

defmodule CloudStorageTest do
  use ExUnit.Case, async: true
  alias Test.Dummy.CloudStorage, as: API

  @endpoint "storage.googleapis.com"

  #########################
  ### GET Service Tests ###
  #########################

  test "list_buckets" do
    expected = build_expected(:get, @endpoint, [{"x-goog-project-id", GCloudex.get_project_id()}], "")

    assert expected == API.list_buckets
  end

  ###########################
  ### DELETE Bucket Tests ###
  ###########################

  test "delete_bucket" do
    expected = build_expected(:delete, "bucket.#{@endpoint}", [], "")

    assert expected == API.delete_bucket "bucket"
  end

  ########################
  ### Get Bucket Tests ###
  ########################

  test "list_objects" do
    expected = build_expected(:get, "bucket.#{@endpoint}", [], "")

    assert expected == API.list_objects "bucket"
  end

  test "list_objects with query from non-empty list" do
    expected = build_expected(
      :get,
      "bucket.#{@endpoint}/?key1=abc&key2=def",
      [],
      ""
    )

    assert expected == API.list_objects "bucket", [{"key1", "abc"}, {"key2", "def"}]
  end

  test "list list_objects with query from empty list" do
    expected = build_expected(
      :get,
      "bucket.#{@endpoint}/?",
      [],
      ""
    )

    assert expected == API.list_objects "bucket", []
  end

  test "get_bucket_acl" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?acl", [], "")

    assert expected == API.get_bucket_acl "bucket"
  end

  test "get_bucket_cors" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?cors", [], "")

    assert expected == API.get_bucket_cors "bucket"
  end

  test "get_bucket_lifecycle" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?lifecycle", [], "")

    assert expected == API.get_bucket_lifecycle "bucket"
  end

  test "get_bucket_region" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?location", [], "")

    assert expected == API.get_bucket_region "bucket"
  end

  test "get_bucket_logging" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?logging", [], "")

    assert expected == API.get_bucket_logging "bucket"
  end

  test "get_bucket_class" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?storageClass", [], "")

    assert expected == API.get_bucket_class "bucket"
  end

  test "get_bucket_versioning" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?versioning", [], "")

    assert expected == API.get_bucket_versioning "bucket"
  end

  test "get_bucket_website" do
    expected = build_expected(:get, "bucket.#{@endpoint}/?website", [], "")

    assert expected == API.get_bucket_website "bucket"
  end

  #########################
  ### HEAD Bucket Tests ###
  #########################

  test "exists_bucket" do
    expected = build_expected(:head, "bucket.#{@endpoint}", [], "")

    assert expected == API.exists_bucket "bucket"
  end

  ########################
  ### PUT Bucket Tests ###
  ########################

  test "create_bucket/1 (default class and region)" do
    expected = build_expected(:put, "bucket.#{@endpoint}", [{"x-goog-project-id", GCloudex.get_project_id()}], "")

    assert expected == API.create_bucket "bucket"
  end

  test "create_bucket/2 (default class and custom region)" do
    region = "region"
    body   =
      """
      <CreateBucketConfiguration>
        <LocationConstraint>#{region}</LocationConstraint>
      </CreateBucketConfiguration>
      """
    expected = build_expected(:put, "bucket.#{@endpoint}", [{"x-goog-project-id", GCloudex.get_project_id()}], body)

    assert expected == API.create_bucket "bucket", region
  end

  test "create_bucket/3 (custom class and custom region)" do
    region = "region"
    class  = "class"
    body   =
      """
      <CreateBucketConfiguration>
        <LocationConstraint>#{region}</LocationConstraint>
        <StorageClass>#{class}</StorageClass>
      </CreateBucketConfiguration>
      """
    expected = build_expected(:put, "bucket.#{@endpoint}", [{"x-goog-project-id", GCloudex.get_project_id()}], body)

    assert expected == API.create_bucket "bucket", region, class
  end

  test "set_bucket_acl" do
    expected = build_expected(:put, "bucket.#{@endpoint}/?acl", [], "acl_config")

    assert expected == API.set_bucket_acl "bucket", "acl_config"
  end

  test "set_bucket_cors" do
    expected = build_expected(:put, "bucket.#{@endpoint}/?cors", [], "cors_config")

    assert expected == API.set_bucket_cors "bucket", "cors_config"
  end

  test "set_bucket_lifecycle" do
    expected = build_expected(:put, "bucket.#{@endpoint}/?lifecycle", [], "lifecycle_config")

    assert expected == API.set_bucket_lifecycle "bucket", "lifecycle_config"
  end

  test "set_bucket_logging" do
    expected = build_expected(:put, "bucket.#{@endpoint}/?logging", [], "logging_config")

    assert expected == API.set_bucket_logging "bucket", "logging_config"
  end

  test "set_bucket_versioning" do
    expected = build_expected(:put, "bucket.#{@endpoint}/?versioning", [], "versioning_config")

    assert expected == API.set_bucket_versioning "bucket", "versioning_config"
  end

  test "set_bucket_website" do
    expected = build_expected(:put, "bucket.#{@endpoint}/?websiteConfig", [], "website_config")

    assert expected == API.set_bucket_website "bucket", "website_config"
  end

  #####################
  ### DELETE Object ###
  #####################

  test "delete_object/2 (no query)" do
    object   = "object"
    expected = build_expected(:delete, "bucket.#{@endpoint}/#{object}", [], "")

    assert expected == API.delete_object "bucket", object
  end

  test "delete_object/3 (with query)" do
    query    = "key1=abc&key2=def"
    object   = "object"
    expected = build_expected(:delete, "bucket.#{@endpoint}/#{object}?#{query}", [], "")

    assert expected == API.delete_object "bucket", object, [{"key1", "abc"}, {"key2", "def"}]
  end

  ##################
  ### GET Object ###
  ##################

  test "get_object/2 (no query)" do
    object   = "object"
    bucket   = "bucket"
    expected = build_expected(:get, "#{bucket}.#{@endpoint}/#{object}", [], "")

    assert expected == API.get_object bucket, object
  end

  test "get_object/3 (with query)" do
    object   = "object"
    bucket   = "bucket"
    query    = "key1=abc&key2=def"
    expected = build_expected(:get, "#{bucket}.#{@endpoint}/#{object}?#{query}", [], "")

    assert expected == API.get_object bucket, object, [{"key1", "abc"}, {"key2", "def"}]
  end

  test "get_object_acl" do
    bucket   = "bucket"
    object   = "object"
    expected = build_expected(:get, "#{bucket}.#{@endpoint}/#{object}?acl", [], "")

    assert expected == API.get_object_acl bucket, object
  end

  ###################
  ### HEAD Object ###
  ###################

  test "get_object_metadata/2 (no query)" do
    bucket   = "bucket"
    object   = "object"
    expected = build_expected(:head, "#{bucket}.#{@endpoint}/#{object}", [], "")

    assert expected == API.get_object_metadata bucket, object
  end

  test "get_object_metadata/3 (with query)" do
    bucket   = "bucket"
    object   = "object"
    query    = "key1=abc&key2=def"
    expected = build_expected(:head, "#{bucket}.#{@endpoint}/#{object}?#{query}", [], "")

    assert expected == API.get_object_metadata bucket, object, [{"key1", "abc"}, {"key2", "def"}]
  end

  ##################
  ### PUT Object ###
  ##################

  test "put_object/2 (no path for the file)" do
    filepath = __DIR__ <> "README.md"
    body     = {:file, filepath}
    bucket   = "bucket"
    expected = build_expected(:put, "#{bucket}.#{@endpoint}/#{filepath}", [], body)

    assert expected == API.put_object bucket, filepath
  end

  test "put_object/3 (with path for the file)" do
    filepath   = __DIR__ <> "README.md"
    bucketpath = "folder_1/folder_2"
    body       = {:file, filepath}
    bucket     = "bucket"
    expected   = build_expected(:put, "#{bucket}.#{@endpoint}/#{bucketpath}", [], body)

    assert expected == API.put_object bucket, filepath, bucketpath
  end

  test "copy_object" do
    new_bucket    = "new_bucket"
    new_object    = "new_object"
    source_object = "source_object"
    expected      = build_expected(
      :put,
      "#{new_bucket}.#{@endpoint}/#{new_object}",
      [{"x-goog-copy-source", source_object}],
      ""
    )

    assert expected == API.copy_object new_bucket, new_object, source_object
  end

  test "set_object_acl/3 (no query)" do
    bucket     = "bucket"
    object     = "object"
    acl_config = "acl_config"
    expected   = build_expected(
      :put,
      "#{bucket}.#{@endpoint}/#{object}?acl",
      [],
      acl_config
    )

    assert expected == API.set_object_acl bucket, object, acl_config
  end

  test "set_object_acl/4 (with query)" do
    bucket     = "bucket"
    object     = "object"
    acl_config = "acl_config"
    query      = "key1=abc&key2=def"
    expected   = build_expected(
      :put,
      "#{bucket}.#{@endpoint}/#{object}?acl&#{query}",
      [],
      acl_config
    )

    assert expected == API.set_object_acl bucket, object, acl_config, [{"key1", "abc"}, {"key2", "def"}]
  end

  ###############
  ### Helpers ###
  ###############

  defp build_expected(verb, host, headers, body, parameters \\ :empty) do
    map = %{
      verb: verb,
      host: host,
      headers:
        headers ++
        [{"Authorization", "Bearer Dummy Token"}],
      body: body,
      opts: []
    }


    if parameters != :empty do
      Map.put(map, host, host <> "/" <> parameters)
    else
      map
    end
  end
end
