defmodule PhoenixBakery.Performance.ZtsdTest do
  use ExUnit.Case

  @assets_dir "test/fixtures/"

  @ztsd_inputs [
    {"compression 1", 1},
    {"compression 2", 2},
    {"compression 3", 3},
    {"compression 4", 4},
    {"compression 5", 5},
    {"compression 6", 6},
    {"compression 7", 7},
    {"compression 8", 8},
    {"compression 9", 9},
    {"compression 10", 10},
    {"compression 11", 11},
    {"compression 12", 12},
    {"compression 13", 13},
    {"compression 14", 14},
    {"compression 15", 15},
    {"compression 16", 16},
    {"compression 17", 17},
    {"compression 18", 18},
    {"compression 19", 19},
    {"compression 20", 20},
    {"compression 21", 21},
    {"compression 22", 22}
  ]

  test "encode files with ztsd" do
    path =
      @assets_dir
      |> Path.join(["regular", "/phoenix_app.min.js"])

    file = File.read!(path)

    Benchee.run(
      %{
        "ztsd" => fn level ->
          assert {:ok, _binary_data} = PhoenixBakery.Zstd.compress_file(path, file, level: level)
        end
      },
      inputs: @ztsd_inputs,
      warmup: 2,
      time: 4,
      memory_time: 1,
      reduction_time: 1,
      formatters: [
        # {Benchee.Formatters.CSV, file: "ztsd_benchmark.csv"},
        Benchee.Formatters.Console
      ]
    )

    for {_label, level} <- @ztsd_inputs do
      IO.inspect(level)
      assert {:ok, binary_data} = PhoenixBakery.Zstd.compress_file(path, file, level: level)
      IO.puts("##### With input #{level} #####")
      IO.puts("compressed size: #{byte_size(binary_data)}")
    end
  end
end
