defmodule PhoenixBakery.Performance.GzipTest do
  use ExUnit.Case

  @assets_dir "test/fixtures/"

  @gzip_inputs [
    {"compression level 1", 1},
    {"compression level 2", 2},
    {"compression level 3", 3},
    {"compression level 4", 4},
    {"compression level 5", 5},
    {"compression level 6", 6},
    {"compression level 7", 7},
    {"compression level 8", 8},
    {"compression level 9", 9}
  ]

  test "encode files with gzip" do
    path =
      @assets_dir
      |> Path.join(["regular", "/phoenix_app.min.js"])

    file = File.read!(path)

    Benchee.run(
      %{
        "gzip" => fn level ->
          PhoenixBakery.Gzip.compress_file(path, file, level: level)
        end
      },
      inputs: @gzip_inputs,
      warmup: 2,
      time: 4,
      memory_time: 1,
      reduction_time: 1,
      formatters: [
        # {Benchee.Formatters.CSV, file: "gzip_benchmark.csv"},
        Benchee.Formatters.Console
      ]
    )

    for {_label, level} <- @gzip_inputs do
      assert {:ok, binary_data} = PhoenixBakery.Gzip.compress_file(path, file, level: level)
      IO.puts("##### With input #{level} #####")
      IO.puts("compressed size: #{byte_size(binary_data)}")
    end
  end
end
