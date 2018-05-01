[![Build Status](https://travis-ci.org/sashaafm/gcloudex.svg?branch=master)](https://travis-ci.org/sashaafm/gcloudex)
# GCloudex

 Google Cloud for Elixir.
 Friendly set of wrappers for Google Cloud Platform services' API's.

## Features
- Minimal configuration and dependencies
- Friendly way to use Google Cloud services' API's
- Function names and signatures closely mimic their REST counterparts
- HTTP requests sent using the popular HTTPoison app providing familiar HTTP responses
- Easy to extend

## Installation and Configuration

GCloudex uses HTTPoison for the HTTP requests, Poison for JSON encoding/decoding and Friendly for XML parsing. The Google Authorization Tokens are retrieved using Goth. The JSON API's for the various Google Cloud services are used whenever possible or available.

  1. Add gcloudex to your list of dependencies in `mix.exs`:

        ```elixir
        def deps do
          [{:gcloudex, git: "git@github.com:sashaafm/gcloudex.git"}]
        end
        ```

  2. Ensure gcloudex is started before your application:

        ```elixir
        def application do
          [applications: [:gcloudex]]
        end
        ```

Then go to the Google Cloud's website and download the credentials file for your Google Project.

Put that file in your application's config folder and rename the file to
`creds.json` (or whatever name you prefer). This file will be used to authenticate the requests. **Be sure to add it to your .gitignore file in case you're uploading to a public repository.**

Finally put inside the config file you want (like `dev.exs`) the following line:

```elixir
config :goth,
  json: "config/<filename>.json" |> Path.expand |> File.read!
```

That's all you need to use GCloudex.

## Usages Examples
### Cloud Storage:
```elixir
GCloudex.CloudStorage.Client.list_buckets # => {:ok, %HTTPoison.Response{body: ..., status_code: 200}}
GCloudex.CloudStorage.CLient.put_object "bucket_name", "this_file.txt" # => {:ok, %HTTPoison.Response{body: ..., status_code: 200}}
```

### Cloud SQL:
```elixir
GCloudex.CloudSQL.Client.list_databases "instance_name" # => {:ok, %HTTPoison.Response{body: ...,status_code: 200}}
GCloudex.CloudSQL.Client-insert_databaes "instance_name", "db_name" # => {:ok, %HTTPoison.Response{body: ...,status_code: 200}}
```

### Cloud Speech:
```elixir
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

iex> GCloudex.CloudSpeech.Client.longrunningrecognize(body)
{:ok,
 %HTTPoison.Response{body: "{\n  \"name\": \"1234567890\"\n}\n",
  headers: [...], status_code: 200}}

iex> GCloudex.CloudSpeech.Client.get("1234567890")
{:ok,
 %HTTPoison.Response{body: "{\n  \"name\": \"1234567890\",\n  \"metadata\": {...
```

## Roadmap

 - [x] Google Cloud Storage
 - [x] Google Cloud SQL
 - [x] Google Compute Engine
 - [X] Google Cloud Speech API (partial)
 - [ ] Google Cloud Datastore
