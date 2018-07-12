defmodule Test.Dummy.CloudSQL do
  use GCloudex.CloudSQL.Impl, :cloud_sql
  require Logger

  def request(verb, endpoint, headers \\ [], body \\ "") do
    %{
      verb: verb,
      host: endpoint,
      body: body,
      headers:
        headers ++
        [
          {"x-goog-project-id", GCloudex.get_project_id()},
          {"Authorization", "Bearer Dummy Token"}
        ],
      opts: []
    }
  end

  def request_query(verb, endpoint, headers, body, parameters) do
    %{
      verb: verb,
      host: endpoint <> "/" <> parameters,
      body: body,
      headers:
        headers ++
        [
          {"x-goog-project-id", GCloudex.get_project_id()},
          {"Authorization", "Bearer Dummy Token"}
        ],
      opts: []
    }
  end
end

defmodule CloudSQLTest do
  use ExUnit.Case, async: true
  alias Test.Dummy.CloudSQL, as: API

  def instance_ep(), do: "https://www.googleapis.com/sql/v1beta4/projects/#{GCloudex.get_project_id()}/instances"
  def flag_ep(), do: "https://www.googleapis.com/sql/v1beta4/flags"
  def operation_ep(), do: "https://www.googleapis.com/sql/v1beta4/projects/#{GCloudex.get_project_id()}/operations"
  def tiers_ep(), do: "https://www.googleapis.com/sql/v1beta4/projects/#{GCloudex.get_project_id()}/tiers"

  #######################
  ### Instances Tests ###
  #######################

  test "list_instances" do
    expected = build_expected(:get, instance_ep(), [], "")

    assert expected == API.list_instances
  end

  test "get_instance" do
    instance = "instance"
    expected = build_expected(:get, instance_ep(), [], "", instance)

    assert expected == API.get_instance instance
  end

  test "insert_instance (no opts)" do
    name     = "name"
    opts     = %{}
    settings = %{settings_1: "abc", settings_2: "def"}
    tier     = "tier"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{
      name: name,
      settings: Map.put(settings, :tier, tier)
    }
    |> Poison.encode!
    expected = build_expected(:post, instance_ep(), headers, body)

    assert expected == API.insert_instance name, opts, settings, tier
  end

  test "insert_instance (with opts)" do
    name     = "name"
    opts     = %{first: "first", second: "second"}
    settings = %{settings_1: "abc", settings_2: "def"}
    tier     = "tier"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{
      name: name,
      settings: Map.put(settings, :tier, tier),
      first: "first",
      second: "second"
    }
    |> Poison.encode!
    expected = build_expected(:post, instance_ep(), headers, body)

    assert expected == API.insert_instance name, opts, settings, tier
  end

  test "delete_instance" do
    instance = "instance"
    headers  = []
    body     = ""
    expected = build_expected(:delete, instance_ep(), headers, body, instance)

    assert expected == API.delete_instance instance
  end

  test "clone_instance" do
    instance     = "instance"
    dest_name    = "dest_name"
    bin_log_file = "bin_log_file"
    bin_log_pos  = "bin_log_pos"
    headers      = [{"Content-Type", "application/json"}]
    body         = %{
      "cloneContext" => %{
        "binLogCoordinates" => %{
          "kind"           => "sql#binLogCoordinates",
          "binLogFileName" => bin_log_file,
          "binLogPosition" => bin_log_pos
        },
        "destinationInstanceName" => dest_name,
        "kind" => "sql#cloneContext"
      }
    } |> Poison.encode!
    expected     = build_expected(:post, instance_ep(), headers, body, "#{instance}/clone")

    assert expected == API.clone_instance instance, dest_name, bin_log_file, bin_log_pos
  end

  test "restart_instance" do
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, instance_ep(), headers, "", "#{instance}/restart")

    assert expected == API.restart_instance instance
  end

  test "start_replica" do
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, instance_ep(), headers, "", "#{instance}/startReplica")

    assert expected == API.start_replica instance
  end

  test "stop_replica" do
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, instance_ep(), headers, "", "#{instance}/stopReplica")

    assert expected == API.stop_replica instance
  end

  test "promote_replica" do
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, instance_ep(), headers, "", "#{instance}/promoteReplica")

    assert expected == API.promote_replica instance
  end

  test "failover_instance" do
    instance         = "instance"
    settings_version = 123
    headers          = [{"Content-Type", "application/json"}]
    body             = %{
      "failoverContext" => %{
        "kind"            => "sql#failoverContext",
        "settingsVersion" => settings_version
      }
    } |> Poison.encode!
    expected = build_expected(:post, instance_ep(), headers, body, "#{instance}/failover")

    assert expected == API.failover_instance instance, settings_version
  end

  test "reset_ssl_config" do
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, instance_ep(), headers, "", "#{instance}/resetSslConfig")

    assert expected == API.reset_ssl_config instance
  end

  #######################
  ### Databases Tests ###
  #######################

  test "list_databases" do
    instance = "instance"
    headers  = []
    expected = build_expected(:get, instance_ep(), headers, "", "#{instance}/databases")

    assert expected == API.list_databases instance
  end

  test "insert_database" do
    instance = "instance"
    name     = "name"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{
      "instance" => instance,
      "name"     => name,
      "project"  => GCloudex.get_project_id()
    } |> Poison.encode!
    expected = build_expected(:post, instance_ep(), headers, body, "#{instance}/databases")

    assert expected == API.insert_database instance, name
  end

  test "get_database" do
    instance = "instance"
    database = "database"
    headers  = []
    body     = ""
    expected = build_expected(:get, instance_ep(), headers, body, "#{instance}/databases/#{database}")

    assert expected == API.get_database instance, database
  end

  test "delete_database" do
    instance = "instance"
    database = "database"
    headers  = []
    body     = ""
    expected = build_expected(:delete, instance_ep(), headers, body, "#{instance}/databases/#{database}")

    assert expected == API.delete_database instance, database
  end

  test "patch_database" do
    instance  = "instance"
    database  = "database"
    patch_map = %{"charset" => "abc", "collation" => "def"}
    headers   = [{"Content-Type", "application/json"}]
    body      = patch_map |> Poison.encode!
    expected  = build_expected(:patch, instance_ep(), headers, body, "#{instance}/databases/#{database}")

    assert expected == API.patch_database instance, database, patch_map
  end

  test "update_database" do
    instance   = "instance"
    database   = "database"
    update_map = %{"field_1" => "abc", "field_2" => "def"}
    headers    = [{"Content-Type", "application/json"}]
    body       = update_map |> Poison.encode!
    expected   = build_expected(:put, instance_ep(), headers, body, "#{instance}/databases/#{database}")

    assert expected == API.update_database instance, database, update_map
  end

  ###################
  ### Flags Tests ###
  ###################

  test "list_flags" do
    headers  = []
    body     = ""
    expected = build_expected(:get, flag_ep(), headers, body)

    assert expected == API.list_flags
  end

  ########################
  ### Operations Tests ###
  ########################

  test "list_operations" do
    instance = "instance"
    headers  = []
    body     = ""
    query    = "?instance=#{instance}"
    expected = build_expected(:get, operation_ep() <> query, headers, body)

    assert expected == API.list_operations instance
  end

  test "get_operation" do
    operation_id = "operation_id"
    headers      = []
    body         = ""
    expected     = build_expected(:get, operation_ep(), headers, body, operation_id)

    assert expected == API.get_operation operation_id
  end

  ###################
  ### Tiers Tests ###
  ###################

  test "list_tiers" do
    headers  = []
    body     = ""
    expected = build_expected(:get, tiers_ep(), headers, body)

    assert expected == API.list_tiers
  end

  ###################
  ### Users Tests ###
  ###################

  test "list_users" do
    instance = "instance"
    headers  = []
    body     = ""
    expected = build_expected(:get, instance_ep(), headers, body, "#{instance}/users")

    assert expected == API.list_users instance
  end

  test "insert_user without host" do
    instance = "instance"
    name     = "name"
    password = "password"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{
      "name"     => name,
      "password" => password,
      "instance" => instance,
      "host"     => "%",
      "project"  => GCloudex.get_project_id()
    } |> Poison.encode!
    expected  = build_expected(:post, instance_ep(), headers, body, "#{instance}/users")

    assert expected == API.insert_user instance, name, password
  end

  test "insert_user with host" do
    instance = "instance"
    name     = "name"
    password = "password"
    host     = "host"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{
      "name"     => name,
      "password" => password,
      "instance" => instance,
      "host"     => host,
      "project"  => GCloudex.get_project_id()
    } |> Poison.encode!
    expected  = build_expected(:post, instance_ep(), headers, body, "#{instance}/users")

    assert expected == API.insert_user instance, name, password, host
  end

  test "update_user" do
    instance = "instance"
    host     = "host"
    name     = "name"
    password = "password"
    query    = "?host=#{host}&name=#{name}"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{"password" => password} |> Poison.encode!
    expected = build_expected(:put, instance_ep(), headers, body, "#{instance}/users#{query}")

    assert expected == API.update_user instance, host, name, password
  end

  test "delete_user" do
    instance = "instance"
    host     = "host"
    name     = "name"
    headers  = []
    query    = "?host=#{host}&name=#{name}"
    body     = ""
    expected = build_expected(:delete, instance_ep(), headers, body, "#{instance}/users#{query}")

    assert expected == API.delete_user instance, host, name
  end

  #########################
  ### Backup Runs Tests ###
  #########################

  test "list_backup_runs" do
    instance = "instance"
    headers  = []
    body     = ""
    expected = build_expected(:get, instance_ep(), headers, body, "#{instance}/backupRuns")

    assert expected == API.list_backup_runs instance
  end

  test "get_backup_run" do
    instance = "instance"
    run_id   = "run_id"
    headers  = []
    body     = ""
    expected = build_expected(:get, instance_ep(), headers, body, "#{instance}/backupRuns/#{run_id}")

    assert expected == API.get_backup_run instance, run_id
  end

  test "delete_backup_run" do
    instance = "instance"
    run_id   = "run_id"
    headers  = []
    body     = ""
    expected = build_expected(:delete, instance_ep(), headers, body, "#{instance}/backupRuns/#{run_id}")

    assert expected == API.delete_backup_run instance, run_id
  end

  ########################
  ### SSL Certificates ###
  ########################

  test "list_ssl_certs" do
    instance = "instance"
    headers  = []
    body     = ""
    expected = build_expected(:get, instance_ep(), headers, body, "#{instance}/sslCerts")

    assert expected == API.list_ssl_certs instance
  end

  test "get_ssl_cert" do
    instance    = "instance"
    fingerprint = "fingerprint"
    headers     = []
    body        = ""
    expected    = build_expected(:get, instance_ep(), headers, body, "#{instance}/sslCerts/#{fingerprint}")

    assert expected == API.get_ssl_cert instance, fingerprint
  end

  test "insert_ssl_cert" do
    instance    = "instance"
    common_name = "common_name"
    headers     = [{"Content-Type", "application/json"}]
    body        = %{"commonName" => common_name} |> Poison.encode!
    expected    = build_expected(:post, instance_ep(), headers, body, "#{instance}/sslCerts")

    assert expected == API.insert_ssl_cert instance, common_name
  end

  test "delete_ssl_cert" do
    instance    = "instance"
    fingerprint = "fingerprint"
    headers     = []
    body        = ""
    expected    = build_expected(:delete, instance_ep(), headers, body, "#{instance}/sslCerts/#{fingerprint}")

    assert expected == API.delete_ssl_cert instance, fingerprint
  end

  test "create_ephemeral_ssl_cert" do
    instance   = "instance"
    public_key = "public_key"
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"public_key" => public_key} |> Poison.encode!
    expected   = build_expected(:post, instance_ep(), headers, body, "#{instance}/createEphemeral")

    assert expected == API.create_ephemeral_ssl_cert instance, public_key
  end
  ########################
  ### Helper Functions ###
  ########################

  defp build_expected(verb, endpoint, headers \\ [], body \\ "", parameters \\ :empty) do
    map = %{
      verb: verb,
      host: endpoint,
      headers:
        headers ++
        [
          {"x-goog-project-id", GCloudex.get_project_id()},
          {"Authorization", "Bearer Dummy Token"}
        ],
      body: body,
      opts: []
    }

    if parameters != :empty do
      Map.put(map, :host, endpoint <> "/" <> parameters)
    else
      map
    end
  end
end
