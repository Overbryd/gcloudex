defmodule GCloudex.CloudSpeech.Request do
  alias HTTPoison, as: HTTP
  alias HTTPoison.HTTPResponse
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  Offers HTTP requests to be used by the Google Cloud Speech wrapper.
  """

  defmacro __using__(_opts) do
    quote do

      @endpoint "speech.googleapis.com"

      @doc"""
      Sends an HTTP request without any query parameters.
      """
      @spec request(atom, binary, binary, list(tuple)) :: HTTPResponse.t
      def request(verb, path, body \\ "", headers \\ []) do
        HTTP.request(
          verb,
          "https://" <> Path.join(@endpoint, path),
          body,
          headers ++ [{"Authorization", "Bearer #{Auth.get_token_storage(:cs)}"},
                      {"x-goog-project-id", GCloudex.get_project_id()}],
          [timeout: 50_000, recv_timeout: 50_000]
        )
      end

      defoverridable [
        request: 4,
      ]
    end
  end
end
