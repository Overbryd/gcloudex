defmodule Test.Dummy.CloudSpeech do
  use ExUnit.Case
  use GCloudex.CloudSpeech.Impl, :cloud_speech

  @endpoint "speech.googleapis.com"

  def request(verb, path, body, headers \\ []) do
    %{
      verb: verb,
      host: Path.join(@endpoint, path),
      body: body,
      headers:
        headers ++
        [
          {"Authorization", "Bearer Dummy Token"},
          {"x-goog-project-id", GCloudex.get_project_id()},
        ],
      opts: []
    }
  end
end

defmodule CloudSpeechTest do
  use ExUnit.Case, async: true
  alias Test.Dummy.CloudSpeech, as: API

  @endpoint "speech.googleapis.com"
  GCloudex.get_project_id() GCloudex.get_project_id

  #########################
  ### POST Speech Tests ###
  #########################

  test "longrunningrecognize/1" do
    body = """
    {
      "audio": {
        "uri": "gs://foo/bar.flac"
      },
      "config": {
        "encoding":"flac",
        "sampleRate": 48000,
        "languageCode":"en-US",
        "maxAlternatives": 1
      }
    }
    """

    expected = build_expected(:post, "v1/speech:longrunningrecognize", [], body)

    assert expected == API.longrunningrecognize(body)
  end

  ########################
  ### GET Speech Tests ###
  ########################

  test "get/0" do
    name = "0123456789"
    expected = build_expected(:get, "v1/operations/#{name}", [], "")
    assert expected == API.get(name)
  end

  ###############
  ### Helpers ###
  ###############

  defp build_expected(verb, path, headers, body) do
    %{
      verb: verb,
      host: Path.join(@endpoint, path),
      headers:
        headers ++
        [{"Authorization", "Bearer Dummy Token"},
         {"x-goog-project-id", GCloudex.get_project_id()}],
      body: body,
      opts: []
    }
  end
end

