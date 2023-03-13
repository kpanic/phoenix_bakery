defmodule PhoenixBakery.Snappy do
  @external_resource "README.md"
  @moduledoc File.read!("README.md")
             |> String.split(~r/<!--\s*(start|end):#{inspect(__MODULE__)}\s*-->/, parts: 3)
             |> Enum.at(1)

  @behaviour Phoenix.Digester.Compressor

  import PhoenixBakery

  require Logger

  @impl true
  def file_extensions, do: ~w[.zst]

  @impl true
  def compress_file(file_path, content) do
    if gzippable?(file_path) do
      compress(content)
    else
      :error
    end
  end

  defp compress(content) do
    case encode(content) do
      {:ok, compressed} when byte_size(compressed) < byte_size(content) ->
        {:ok, compressed}

      error ->
        IO.inspect(error, label: "ERROR")
        :error
    end
  end

  defp encode(content) do
    cond do
      Code.ensure_loaded?(:snappyer) and function_exported?(:snappyer, :compress, 1) ->
        :snappyer.compress(content)

      # path = find_executable(:snappy) ->
      #   run(:snappyer, content, path, ~w[-c --ultra -#{options.level}])

      true ->
        raise "No `snappy` utility"
    end
  end
end
