defmodule PhoenixBakery.Performance.BrotliTest do
  use ExUnit.Case

  @assets_dir "test/fixtures/"

  @brotli_inputs [
    {"compression quality 1", 1},
    # For some reason the brotli compressor does not work with these two quality numbers.
    # {"compression quality 2", 2},
    # {"compression quality 3", 3},
    {"compression quality 4", 4},
    {"compression quality 5", 5},
    {"compression quality 6", 6},
    {"compression quality 7", 7},
    {"compression quality 8", 8},
    {"compression quality 9", 9},
    {"compression quality 10", 10},
    {"compression quality 11", 11}
  ]

  test "encode files with brotli" do
    path =
      @assets_dir
      |> Path.join(["regular", "/phoenix_app.min.js"])

    file = File.read!(path)

    Benchee.run(
      %{
        "brotli" => fn quality ->
          assert {:ok, _binary_data} =
                   PhoenixBakery.Brotli.compress_file(path, file, quality: quality)
        end
      },
      inputs: @brotli_inputs,
      warmup: 2,
      time: 4,
      memory_time: 1,
      reduction_time: 1,
      formatters: [
        # {Benchee.Formatters.CSV, file: "brotli_benchmark.csv"},
        Benchee.Formatters.Console
      ]
    )

    for {_label, quality} <- @brotli_inputs do
      IO.inspect(quality)
      assert {:ok, binary_data} = PhoenixBakery.Brotli.compress_file(path, file, quality: quality)
      IO.puts("##### With input #{quality} #####")
      IO.puts("compressed size: #{byte_size(binary_data)}")
    end
  end
end
