defmodule PhoenixBakery.Performance.Snappy do
  use ExUnit.Case

  @assets_dir "test/fixtures/"

  test "encode files with snappy" do
    path =
      @assets_dir
      |> Path.join(["regular", "/phoenix_app.min.js"])

    file = File.read!(path)

    Benchee.run(
      %{
        "snappy" => fn ->
          assert {:ok, _binary_data} = PhoenixBakery.Snappy.compress_file(path, file)
        end
      },
      # inputs: @snappy_inputs,
      warmup: 2,
      time: 4,
      memory_time: 1,
      reduction_time: 1,
      formatters: [
        # {Benchee.Formatters.CSV, file: "snappy_benchmark.csv"},
        Benchee.Formatters.Console
      ]
    )

    assert {:ok, binary_data} = PhoenixBakery.Snappy.compress_file(path, file)
    IO.puts("compressed size: #{byte_size(binary_data)}")
  end
end
