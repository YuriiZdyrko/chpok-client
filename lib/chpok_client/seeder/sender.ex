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
      encoded = Base.encode64(binary)

      IO.puts("Sending file: #{path}")

      # TODO: implement without timeout
      SeederChannel.push("new:msg", %{msg: encoded, dst_path: dst_path, leacher: leacher}, [timeout: 10000])
    end)
  end
end
