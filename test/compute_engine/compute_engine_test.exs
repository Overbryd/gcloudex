defmodule Test.Dummy.ComputeEngine do
  use GCloudex.ComputeEngine.Impl, :compute_engine

  def request(verb, endpoint, headers, body, query \\ "") do
    %{
      verb: verb,
      endpoint: endpoint,
      body: body,
      headers:
        headers ++
        [
          {"x-goog-project-id", GCloudex.get_project_id()},
          {"Authorization", "Bearer Dummy Token"}
        ],
      query: query
    }
  end
end

defmodule ComputeEngineTest do
  use ExUnit.Case, async: true
  alias Test.Dummy.ComputeEngine, as: API

  def instance_ep(), do: "https://www.googleapis.com/compute/v1/projects/#{GCloudex.get_project_id()}/zones"
  def no_zone_ep(), do: "https://www.googleapis.com/compute/v1/projects/#{GCloudex.get_project_id()}"

  #########################
  ### Autoscalers Tests ###
  #########################

  test "list_autoscalers (no fields)" do
    zone     = "zone"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_autoscalers zone
  end

  test "list_autoscalers (with fields)" do
    zone     = "zone"
    headers  = []
    body     = ""
    query    = %{"key1" => "abc", "key2" => "def"}
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_autoscalers zone, query
  end

  test "get_autoscaler (no fields)" do
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    _query     = %{}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_autoscaler zone, autoscaler
  end

  test "get_autoscaler (with fields)" do
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_autoscaler zone, autoscaler, fields
  end

  test "insert_autoscaler (no fields)" do
    zone       = "zone"
    resource   = %{"name" => "abc", "target" => "def"}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_autoscaler zone, resource
  end

  test "insert_autoscaler (with fields)" do
    zone       = "zone"
    resource   = %{"name" => "abc", "target" => "def"}
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = resource |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_autoscaler zone, resource, fields
  end

  test "patch_autoscaler (no fields)" do
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    query    = %{"autoscaler" => name}
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:patch, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.patch_autoscaler zone, name, resource
  end

  test "patch_autoscaler (with fields)" do
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"autoscaler" => name, "fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:patch, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.patch_autoscaler zone, name, resource, fields
  end

  test "update_autoscaler (no fields)" do
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    query    = %{"autoscaler" => name}
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, name, resource
  end

  test "update_autoscaler (with fields)" do
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"autoscaler" => name, "fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, name, resource, fields
  end

  test "update_autoscaler (no name)" do
    zone     = "zone"
    name     = ""
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, "", resource, fields
  end

  test "update_autoscaler (no fields no name)" do
    zone     = "zone"
    name     = ""
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    query    = %{}
    endpoint = no_zone_ep() <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, "", resource
  end

  test "delete_autoscaler (no fields)" do
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_autoscaler zone, autoscaler
  end

  test "delete_autoscaler (with fields)" do
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_autoscaler zone, autoscaler, fields
  end

  test "aggregated_list_of_autoscalers (no query)" do
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/aggregated/autoscalers"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_autoscalers
  end

  test "aggregated_list_of_autoscalers (with query)" do
    headers  = []
    body     = ""
    query    = %{"field1" => "abc", "field2" => "def"}
    endpoint = no_zone_ep() <> "/aggregated/autoscalers"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_autoscalers query
  end

  #######################
  ### DiskTypes Tests ###
  #######################

  test "list_disk_types (no query)" do
    zone       = "zone"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_disk_types zone
  end

  test "list_disk_types (with query)" do
    zone       = "zone"
    headers    = []
    body       = ""
    query      = %{"field1" => "abc", "field2" => "def"}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_disk_types zone, query
  end

  test "get_disk_type (no fields)" do
    zone       = "zone"
    disk_type  = "disk_type"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/diskTypes/#{disk_type}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_disk_type zone, disk_type
  end

  test "get_disk_type (with fields)" do
    zone       = "zone"
    disk_type  = "disk_type"
    headers    = []
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/diskTypes/#{disk_type}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_disk_type zone, disk_type, fields
  end

  test "aggregated_list_of_disk_types (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/aggregated/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_disk_types
  end

  test "aggregated_list_of_disk_types (with query)" do
    headers    = []
    body       = ""
    query      = %{"field1" => 1, "field2" => 2}
    endpoint   = no_zone_ep() <> "/aggregated/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_disk_types query
  end

  ###################
  ### Disks Tests ###
  ###################

  test "list_disks (no query)" do
    zone       = "zone"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_disks zone
  end

  test "list_disks (with query)" do
    zone       = "zone"
    headers    = []
    body       = ""
    query      = %{"a" => 1, "b" => 2}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_disks zone, query
  end

  test "get_disk (no fields)" do
    zone       = "zone"
    disk       = "disk"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_disk zone, disk
  end

  test "get_disk (with fields)" do
    zone       = "zone"
    disk       = "disk"
    headers    = []
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_disk zone, disk, fields
  end

  test "insert_disk (no fields with image)" do
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = "source_image"
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    query      = %{"sourceImage" => source_img}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img
  end

  test "insert_disk (with fields with image)" do
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = "source_image"
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    body       = resource |> Poison.encode!
    query      = %{"sourceImage" => source_img, "fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img, fields
  end

  test "insert_disk (with fields no image)" do
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = ""
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    body       = resource |> Poison.encode!
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img, fields
  end

  test "insert_disk (no fields no image)" do
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = ""
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    query      = %{}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img
  end

  test "delete_disk (no fields)" do
    zone       = "zone"
    disk       = "disk"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_disk zone, disk
  end

  test "delete_disk (with fields)" do
    zone       = "zone"
    disk       = "disk"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_disk zone, disk, fields
  end

  test "resize_disk (no fields)" do
    zone       = "zone"
    disk       = "disk"
    size       = 10
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"sizeGb" => size} |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}/resize"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.resize_disk zone, disk, size
  end

  test "resize_disk (with fields)" do
    zone       = "zone"
    disk       = "disk"
    size       = 10
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"sizeGb" => size} |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}/resize"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.resize_disk zone, disk, size, fields
  end

  test "aggregated_list_of_disks (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/aggregated/disks"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_disks
  end

  test "aggregated_list_of_disks (with query)" do
    headers    = []
    body       = ""
    query      = %{"field1" => 1, "field2" => 2}
    endpoint   = no_zone_ep() <> "/aggregated/disks"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_disks query
  end

  test "create_snapshot (no fields)" do
    zone       = "zone"
    disk       = "disk"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}/createSnapshot"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.create_snapshot zone, disk, resource
  end

  test "create_snapshot (with fields)" do
    zone       = "zone"
    disk       = "disk"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = resource |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/disks/#{disk}/createSnapshot"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.create_snapshot zone, disk, resource, fields
  end

  #######################
  ### Firewalls Tests ###
  #######################

  test "list_firewalls (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/global/firewalls"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_firewalls
  end

  test "list_firewalls (with query)" do
    headers    = []
    body       = ""
    query      = %{"a" => 1, "b" => 2}
    endpoint   = no_zone_ep() <> "/global/firewalls"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_firewalls query
  end

  test "get_firewall (no fields)" do
    firewall   = "firewall"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_firewall firewall
  end

  test "get_firewall (with fields)" do
    firewall   = "firewall"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_firewall firewall, fields
  end

  test "insert_firewall (no fields)" do
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = no_zone_ep() <> "/global/firewalls"
    expected = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_firewall resource
  end

  test "insert_firewall (with fields)" do
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/firewalls"
    expected = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_firewall resource, fields
  end

  test "patch_firewall (no fields)" do
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected = build_expected(:patch, endpoint, headers, body)

    assert expected == API.patch_firewall firewall, resource
  end

  test "patch_firewall (with fields)" do
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected = build_expected(:patch, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.patch_firewall firewall, resource, fields
  end

  test "update_firewall (no fields)" do
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected = build_expected(:put, endpoint, headers, body)

    assert expected == API.update_firewall firewall, resource
  end

  test "update_firewall (with fields)" do
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_firewall firewall, resource, fields
  end

  test "delete_firewall (no fields)" do
    firewall = "firewall"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_firewall firewall
  end

  test "delete_firewall (with fields)" do
    firewall = "firewall"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/firewalls/#{firewall}"
    expected = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_firewall firewall, fields
  end

  ####################
  ### Images Tests ###
  ####################

  test "list_images (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/global/images"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_images
  end

  test "list_images (with query)" do
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = no_zone_ep() <> "/global/images"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_images query
  end

  test "get_image (no fields)" do
    image      = "image"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/global/images/#{image}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_image image
  end

  test "get_image (with fields)" do
    image      = "image"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/global/images/#{image}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_image image
  end

  test "insert_image_with_resource (no fields)" do
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = no_zone_ep() <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_image_with_resource resource
  end

  test "insert_image_with_resource (with fields)" do
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_image_with_resource resource, fields
  end

  test "insert_image (no fields)" do
    name       = "name"
    url        = "url"
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"name" => name, "rawDisk" => %{"source" => url}} |> Poison.encode!
    endpoint   = no_zone_ep() <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_image name, url
  end

  test "insert_image (with fields)" do
    name       = "name"
    url        = "url"
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = %{"name" => name, "rawDisk" => %{"source" => url}} |> Poison.encode!
    endpoint   = no_zone_ep() <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_image name, url, fields
  end

  test "delete_image (no fields)" do
    image      = "image"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/global/images/#{image}"
    expected   = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_image image
  end

  test "delete_image (with fields)" do
    image      = "image"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/global/images/#{image}"
    expected   = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_image image, fields
  end

  test "deprecate_image (no fields)" do
    image      = "image"
    request    = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = request |> Poison.encode!
    endpoint   = no_zone_ep() <> "/global/images/#{image}/deprecate"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.deprecate_image image, request
  end

  test "deprecate_image (with fields)" do
    image      = "image"
    request    = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = request |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/global/images/#{image}/deprecate"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.deprecate_image image, request, fields
  end

  ############################
  ### InstanceGroups Tests ###
  ############################

  test "list_instance_groups (no query)" do
    zone       = "zone"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_instance_groups zone
  end

  test "list_instance_groups (with query)" do
    zone       = "zone"
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_instance_groups zone, query
  end

  test "list_instances_in_group (no query)" do
    zone       = "zone"
    group      = "group"
    state      = "state"
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"instanceState" => state} |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/listInstances"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.list_instances_in_group zone, group, state
  end

  test "list_instances_in_group (with) query)" do
    zone       = "zone"
    group      = "group"
    state      = "state"
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"instanceState" => state} |> Poison.encode!
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/listInstances"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_instances_in_group zone, group, state, query
  end

  test "get_instance_group (no fields)" do
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_instance_group zone, group
  end

  test "get_instance_group (with fields)" do
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_instance_group zone, group, fields
  end

  test "insert_instance_group (no fields)" do
    zone       = "zone"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_instance_group zone, resource
  end

  test "insert_instance_group (with fields)" do
    zone       = "zone"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_instance_group zone, resource, fields
  end

  test "delete_instance_group (no fields)" do
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_instance_group zone, group
  end

  test "delete_instance_group (with fields)" do
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_instance_group zone, group, fields
  end

  test "aggregated_list_of_instance_groups (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/aggregated/instanceGroups"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_instance_groups
  end

  test "aggregated_list_of_instance_groups (with query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/aggregated/instanceGroups"
    query      = %{"abc" => 1, "def" => 2}
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_instance_groups query
  end

  test "add_instances_to_group (no fields)" do
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/addInstances"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.add_instances_to_group zone, group, instances
  end

  test "add_instances_to_group (with fields)" do
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/addInstances"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.add_instances_to_group zone, group, instances, fields
  end

  test "remove_instances_from_group (no fields)" do
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/removeInstances"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.remove_instances_from_group zone, group, instances
  end

  test "remove_instances_from_group (with fields)" do
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/removeInstances"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.remove_instances_from_group zone, group, instances, fields
  end

  test "set_named_ports_for_group (no fields)" do
    zone       = "zone"
    group      = "group"
    fp         = "fingerprint"
    ports      = [{"a", "1"}, {"b", "2"}, {"c", "3"}]
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "namedPorts" => [
        %{"name" => "a", "port" => "1"},
        %{"name" => "b", "port" => "2"},
        %{"name" => "c", "port" => "3"}
      ],
      "fingerprint" => fp
    } |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/setNamedPorts"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_named_ports_for_group zone, group, ports, fp
  end

  test "set_named_ports_for_group (with fields)" do
    zone       = "zone"
    group      = "group"
    fp         = "fingerprint"
    ports      = [{"a", "1"}, {"b", "2"}, {"c", "3"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "namedPorts" => [
        %{"name" => "a", "port" => "1"},
        %{"name" => "b", "port" => "2"},
        %{"name" => "c", "port" => "3"}
      ],
      "fingerprint" => fp
    } |> Poison.encode!
    endpoint   = no_zone_ep() <> "/zones/#{zone}/instanceGroups/#{group}/setNamedPorts"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_named_ports_for_group zone, group, ports, fp
  end

  #######################
  ### Instances Tests ###
  #######################

  test "list_instances (no query)" do
    zone     = "zone"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_instances zone
  end

  test "list_instances (with query)" do
    zone     = "zone"
    headers  = []
    body     = ""
    query    = %{"abc" => 1, "def" => 2}
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_instances zone, query
  end

  test "get_instance (no fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_instance zone, instance
  end

  test "get_instance (with fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_instance zone, instance, fields
  end

  test "insert_instance (no fields)" do
    zone     = "zone"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances"
    expected = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_instance zone, resource
  end

  test "insert_instance (with fields)" do
    zone     = "zone"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances"
    expected = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_instance zone, resource, fields
  end

  test "delete_instance (no fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}"
    expected = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_instance zone, instance
  end

  test "delete_instance (with fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}"
    expected = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_instance zone, instance, fields
  end

  test "start_instance (no fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/start"
    expected = build_expected(:post, endpoint, headers, body)

    assert expected == API.start_instance zone, instance
  end

  test "start_instance (with fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/start"
    expected = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.start_instance zone, instance, fields
  end

  test "stop_instance (no fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/stop"
    expected = build_expected(:post, endpoint, headers, body)

    assert expected == API.stop_instance zone, instance
  end

  test "stop_instance (with fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/stop"
    expected = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.stop_instance zone, instance, fields
  end

  test "reset_instance (no fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/reset"
    expected = build_expected(:post, endpoint, headers, body)

    assert expected == API.reset_instance zone, instance
  end

  test "reset_instance (with fields)" do
    zone     = "zone"
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/reset"
    expected = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.reset_instance zone, instance, fields
  end

  test "add_access_config (no fields with nat)" do
    zone      = "zone"
    instance  = "instance"
    interface = "interface"
    name      = "name"
    nat       = "nat"
    headers   = [{"Content-Type", "application/json"}]
    query     = %{"networkInterface" => interface}
    body      = %{
      "kind"   => "compute#accessConfig",
      "type"   => "ONE_TO_ONE_NAT",
      "name"   => name,
      "natIP"  => nat
    } |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/addAccessConfig"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.add_access_config zone, instance, interface, name, nat
  end

  test "add_access_config (no fields no nat)" do
    zone      = "zone"
    instance  = "instance"
    interface = "interface"
    name      = "name"
    nat       = ""
    headers   = [{"Content-Type", "application/json"}]
    query     = %{"networkInterface" => interface}
    body      = %{
      "kind" => "compute#accessConfig",
      "type" => "ONE_TO_ONE_NAT",
      "name" => name,
    } |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/addAccessConfig"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.add_access_config zone, instance, interface, name, nat
  end

  test "add_access_config (with fields with nat)" do
    zone      = "zone"
    instance  = "instance"
    interface = "interface"
    name      = "name"
    nat       = "nat"
    headers   = [{"Content-Type", "application/json"}]
    fields    = "a,b,c"
    query     = %{"networkInterface" => interface, "fields" => fields}
    body      = %{
      "kind"   => "compute#accessConfig",
      "type"   => "ONE_TO_ONE_NAT",
      "name"   => name,
      "natIP"  => nat
    } |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/addAccessConfig"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.add_access_config zone, instance, interface, name, nat, fields
  end

  test "add_access_config (no fields no interface)" do
    zone      = "zone"
    instance  = "instance"
    interface = "interface"
    name      = "name"
    nat       = ""
    headers   = [{"Content-Type", "application/json"}]
    query     = %{
      "networkInterface" => interface,
    }
    body      = %{
      "kind"   => "compute#accessConfig",
      "type"   => "ONE_TO_ONE_NAT",
      "name"   => name,
    } |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/addAccessConfig"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.add_access_config zone, instance, interface, name, nat
  end

  test "delete_access_config (no fields)" do
    zone      = "zone"
    instance  = "instance"
    interface = "interface"
    config    = "accessConfig"
    headers   = [{"Content-Type", "application/json"}]
    query     = %{"networkInterface" => interface, "accessConfig" => config}
    body      = ""
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/deleteAccessConfig"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_access_config zone, instance, config, interface
  end

  test "delete_access_config (with fields)" do
    zone      = "zone"
    instance  = "instance"
    interface = "interface"
    config    = "accessConfig"
    headers   = [{"Content-Type", "application/json"}]
    fields    = "a,b,c"
    query     = %{
      "networkInterface" => interface,
      "accessConfig"     => config,
      "fields"           => fields
    }
    body      = ""
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/deleteAccessConfig"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_access_config zone, instance, config, interface, fields
  end

  test "aggregated_list_of_instances (no query)" do
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/aggregated/instances"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_instances
  end

  test "aggregated_list_of_instances (with query)" do
    headers  = []
    body     = ""
    query    = %{"abc" => 1, "def" => 2}
    endpoint = no_zone_ep() <> "/aggregated/instances"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_instances query
  end

  test "attach_disk (no fields)" do
    zone      = "zone"
    instance  = "instance"
    resource  = %{"abc" => 1, "def" => 2}
    headers   = [{"Content-Type", "application/json"}]
    body      = resource |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/attachDisk"
    expected  = build_expected(:post, endpoint, headers, body)

    assert expected == API.attach_disk zone, instance, resource
  end

  test "attach_disk (with fields)" do
    zone      = "zone"
    instance  = "instance"
    resource  = %{"abc" => 1, "def" => 2}
    headers   = [{"Content-Type", "application/json"}]
    body      = resource |> Poison.encode!
    fields    = "a,b,c"
    query     = %{"fields" => fields}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/attachDisk"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.attach_disk zone, instance, resource, fields
  end

  test "detach_disk (no fields)" do
    zone      = "zone"
    instance  = "instance"
    device    = "device"
    headers   = [{"Content-Type", "application/json"}]
    body      = ""
    query     = %{"deviceName" => device}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/detachDisk"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.detach_disk zone, instance, device
  end

  test "detach_disk (with fields)" do
    zone      = "zone"
    instance  = "instance"
    device    = "device"
    headers   = [{"Content-Type", "application/json"}]
    body      = ""
    fields    = "a,b,c"
    query     = %{"deviceName" => device, "fields" => fields}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/detachDisk"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.detach_disk zone, instance, device, fields
  end

  test "set_disk_auto_delete (no fields)" do
    zone      = "zone"
    instance  = "instance"
    delete    = true
    device    = "device"
    headers   = [{"Content-Type", "application/json"}]
    body      = ""
    query     = %{"deviceName" => device, "autoDelete" => delete}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setDiskAutoDelete"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.set_disk_auto_delete zone, instance, delete, device
  end

  test "set_disk_auto_delete (with fields)" do
    zone      = "zone"
    instance  = "instance"
    delete    = true
    device    = "device"
    headers   = [{"Content-Type", "application/json"}]
    body      = ""
    fields    = "a,b,c"
    query     = %{
      "deviceName" => device,
      "autoDelete" => delete,
      "fields"     => fields
    }
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setDiskAutoDelete"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.set_disk_auto_delete zone, instance, delete, device, fields
  end

  test "get_serial_port_output (no fields)" do
    zone      = "zone"
    instance  = "instance"
    port      = 1
    headers   = []
    body      = ""
    query     = %{"port" => port}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/serialPort"
    expected  = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_serial_port_output zone, instance, port
  end

  test "get_serial_port_output (with fields)" do
    zone      = "zone"
    instance  = "instance"
    port      = 1
    headers   = []
    body      = ""
    fields    = "a,b,c"
    query     = %{"port" => port, "fields" => fields}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/serialPort"
    expected  = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_serial_port_output zone, instance, port, fields
  end

  test "set_machine_type (no fields)" do
    zone      = "zone"
    instance  = "instance"
    type      = "type"
    headers   = [{"Content-Type", "application/json"}]
    body      = %{"machineType" => type} |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setMachineType"
    expected  = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_machine_type zone, instance, type
  end

  test "set_machine_type (with fields)" do
    zone      = "zone"
    instance  = "instance"
    type      = "type"
    headers   = [{"Content-Type", "application/json"}]
    body      = %{"machineType" => type} |> Poison.encode!
    fields    = "a,b,c"
    query     = %{"fields" => fields}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setMachineType"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.set_machine_type zone, instance, type, fields
  end

  test "set_metadata (no fields)" do
    zone      = "zone"
    instance  = "instance"
    fp        = "fingerprint"
    items     = [
      %{"key" => "val1", "value" => "val2"},
      %{"key" => "val3", "value" => "val4"}
    ]
    headers   = [{"Content-Type", "application/json"}]
    body      = %{
      "kind"        => "compute#metadata",
      "fingerprint" => fp,
      "items"       => items
    } |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setMetadata"
    expected  = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_metadata zone, instance, fp, items
  end

  test "set_metadata (with fields)" do
    zone      = "zone"
    instance  = "instance"
    fp        = "fingerprint"
    items     = [
      %{"key" => "val1", "value" => "val2"},
      %{"key" => "val3", "value" => "val4"}
    ]
    headers   = [{"Content-Type", "application/json"}]
    body      = %{
      "kind"        => "compute#metadata",
      "fingerprint" => fp,
      "items"       => items
    } |> Poison.encode!
    fields    = "a,b,c"
    query     = %{"fields" => fields}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setMetadata"
    expected  = build_expected(:post, endpoint, headers, body, query)

    assert expected == API.set_metadata zone, instance, fp, items, fields
  end

  test "set_scheduling (no fields)" do
    zone      = "zone"
    instance  = "instance"
    on_host   = "abc"
    restart   = true
    pre       = true
    headers   = [{"Content-Type", "application/json"}]
    body      = %{
      "onHostMaintenance" => on_host,
      "automaticRestart"  => restart,
      "preemptible"       => pre
    } |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setScheduling"
    expected  = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_scheduling zone, instance, {on_host, restart, pre}
  end

  test "set_scheduling (with fields)" do
    zone      = "zone"
    instance  = "instance"
    on_host   = "abc"
    restart   = true
    pre       = true
    headers   = [{"Content-Type", "application/json"}]
    body      = %{
      "onHostMaintenance" => on_host,
      "automaticRestart"  => restart,
      "preemptible"       => pre
    } |> Poison.encode!
    fields    = "a,b,c"
    query     = %{"fields" => fields}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setScheduling"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.set_scheduling zone, instance, {on_host, restart, pre}, fields
  end

  test "set_tags (no fields)" do
    zone      = "zone"
    instance  = "instance"
    fp        = "fingerprint"
    items     = ["abc", "def"]
    headers   = [{"Content-Type", "application/json"}]
    body      = %{
      "items"       => items,
      "fingerprint" => fp
    } |> Poison.encode!
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setTags"
    expected  = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_tags zone, instance, fp, items
  end

  test "set_tags (with fields)" do
    zone      = "zone"
    instance  = "instance"
    fp        = "fingerprint"
    items     = ["abc", "def"]
    headers   = [{"Content-Type", "application/json"}]
    body      = %{
      "items"       => items,
      "fingerprint" => fp
    } |> Poison.encode!
    fields    = "a,b,c"
    query     = %{"fields" => fields}
    endpoint  = no_zone_ep() <> "/zones/#{zone}/instances/#{instance}/setTags"
    expected  = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.set_tags zone, instance, fp, items, fields
  end

  ######################
  ### Licenses Tests ###
  ######################

  test "get_license (no fields)" do
    license  = "license"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/global/licenses/#{license}"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_license license
  end

  test "get_license (with fields)" do
    license  = "license"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/licenses/#{license}"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_license license, fields
  end

  #####################
  ### Regions Tests ###
  #####################

  test "list_regions (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/regions"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_regions
  end

  test "list_regions (with query)" do
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = no_zone_ep() <> "/regions"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_regions query
  end

  test "get_region (no fields)" do
    region   = "region"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/regions/#{region}"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_region region
  end

  test "get_region (with fields)" do
    region   = "region"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/regions/#{region}"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_region region, fields
  end

  ##########################
  ### MachineTypes Tests ###
  ##########################

  test "list_machine_types (no query)" do
    zone     = "zone"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/machineTypes"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_machine_types zone
  end

  test "list_machine_types (with query)" do
    zone     = "zone"
    headers  = []
    body     = ""
    query    = %{"abc" => 1, "def" => 2}
    endpoint = no_zone_ep() <> "/zones/#{zone}/machineTypes"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_machine_types zone, query
  end

  test "get_machine_type (no fields)" do
    zone     = "zone"
    type     = "machine_type"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}/machineTypes/#{type}"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_machine_type zone, type
  end

  test "get_machine_type (with fields)" do
    zone     = "zone"
    type     = "machine_type"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}/machineTypes/#{type}"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_machine_type zone, type, fields
  end

  test "aggregated_list_of_machine_types (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/aggregated/machineTypes"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_machine_types
  end

  test "aggregated_list_of_machine_types (with query)" do
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = no_zone_ep() <> "/aggregated/machineTypes"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_machine_types query
  end

  ######################
  ### Networks Tests ###
  ######################

  test "list_networks (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/global/networks"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_networks
  end

  test "list_networks (with query)" do
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = no_zone_ep() <> "/global/networks"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_networks query
  end

  test "get_network (no fields)" do
    network  = "network"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/global/networks/#{network}"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_network network
  end

  test "get_network (with fields)" do
    network  = "network"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/networks/#{network}"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_network network, fields
  end

  test "insert_network (no fields)" do
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = no_zone_ep() <> "/global/networks"
    expected = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_network resource
  end

  test "insert_network (with fields)" do
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/networks"
    expected = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_network resource, fields
  end

  test "delete_network (no fields)" do
    network  = "network"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/global/networks/#{network}"
    expected = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_network network
  end

  test "delete_network (with fields)" do
    network  = "network"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/global/networks/#{network}"
    expected = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_network network, fields
  end

  ###################
  ### Zones Tests ###
  ###################

  test "list_zones (no query)" do
    headers    = []
    body       = ""
    endpoint   = no_zone_ep() <> "/zones"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_zones
  end

  test "list_zones (with query)" do
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = no_zone_ep() <> "/zones"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_zones query
  end

  test "get_zone (no fields)" do
    zone     = "zone"
    headers  = []
    body     = ""
    endpoint = no_zone_ep() <> "/zones/#{zone}"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_zone zone
  end

  test "get_zone (with fields)" do
    zone     = "zone"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = no_zone_ep() <> "/zones/#{zone}"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_zone zone, fields
  end

  ###############
  ### Helpers ###
  ###############

  defp build_expected(verb, host, headers, body, query \\ "") do
    %{
      verb: verb,
      endpoint: host,
      headers:
        headers ++
        [
          {"x-goog-project-id", GCloudex.get_project_id()},
          {"Authorization", "Bearer Dummy Token"}
        ],
      body: body,
      query: query
    }
  end
end
