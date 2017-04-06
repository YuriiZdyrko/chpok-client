defmodule ChpokClient.Seeder.Sender do

  alias ChpokClient.SeederChannel
  alias ChpokClient.Utils.FileExt

  @doc """
  Collect files from folder, send each file synchronously to Proxy
  """
  def run(leacher) do
    src_dir = Application.get_env(:chpok_client, :dir)

    FileExt.ls_r(src_dir)
    |> Enum.each(fn(path) ->

      dst_path = String.replace_prefix(path, src_dir, "")

      {:ok, binary} = File.read(path)

      binary
      |> Base.encode64
      |> (fn(encoded_binary) ->
        IO.puts("Sending file: #{path}")
        SeederChannel.push("new:msg", %{msg: encoded_binary, dst_path: dst_path, leacher: leacher})
      end).()
    end)
  end
end
