defmodule ChpokClient.Seeder.Sender do

  alias ChpokClient.SeederChannel
  alias ChpokClient.Utils.FileExt

  @moduledoc """
  Send files one by one,
  waiting for ack from Leacher to avoid bottlenecks
  """

  use GenServer

  def start_link(leacher) do
    GenServer.start_link(__MODULE__, leacher, [name: __MODULE__])
  end

  def init(leacher) do
    IO.puts("RESTART")
    {:ok, leacher, 0}
  end

  def send_file(path, leacher) do
    name = Application.get_env(:chpok_client, :name)
    src_dir = Application.get_env(:chpok_client, :dir)
    {:ok, binary} = File.read(path)
    dst_path = String.replace_prefix(path, src_dir, "")
    encoded = Base.encode64(binary)

    IO.puts("[ACTION] Sending file: #{path}")

    SeederChannel.push(
      "new:" <> dst_path,
      %{msg: encoded, dst_path: dst_path, leacher: leacher, seeder: name},
      [timeout: 10000]
    )

    receive do
      {:ack, ^dst_path} ->
        "[OK] Receive acknowledged: #{dst_path}"
      after 10000 ->
        Process.exit(__MODULE__, :kill)
    end
  end

  def handle_info(:timeout, leacher) do
    src_dir = Application.get_env(:chpok_client, :dir)

    result = FileExt.ls_r(src_dir)
      |> exclude_large_files
      |> Enum.each(fn(path) -> send_file(path, leacher) end)

    IO.puts("[OK] Transaction completed")
    {:noreply, leacher}
  end

  defp exclude_large_files(paths) do
    Enum.filter(paths, fn(path) ->
      %{size: size} = File.stat! path
      size < 1000
    end)
  end
end
