defmodule GCloudex.ComputeEngine.Request do
  alias GCloudex.Auth, as: Auth

  @moduledoc """

  """

  defmacro __using__(_opts) do
    quote do
      require Logger

      @doc """

      """
      @spec request(verb :: atom, endpoint :: binary, headers :: [{binary, binary}], body :: binary, parameters :: binary) :: HTTPResponse.t
      def request(verb, endpoint, headers \\ [], body \\ "", parameters \\ "") do
        endpoint =
          if parameters == "" do
            endpoint
          else
            endpoint <> "/" <> "?" <> parameters
          end

        HTTPoison.request(
          verb,
          endpoint,
          body,
          headers ++ [{"x-goog-project-id", project_id()},
                      {"Authorization", "Bearer #{Auth.get_token_storage(:compute)}"}],
          []
          )
      end

      defoverridable [request: 4, request: 5]

      defp project_id, do: GCloudex.get_project_id()
    end
  end
end
