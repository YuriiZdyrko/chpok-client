defmodule ChpokClient.Seeder do

  alias ChpokClient.SeederChannel

  def run do
    name = Application.get_env(:chpok_client, :name)
    with {:ok, _socket} <- ClientSocket.start_link,
      {:ok, _channel} <- PhoenixChannelClient.channel(
      SeederChannel,
      socket: ClientSocket,
      topic: "seeders:#{name}"
    )
    do
      IO.puts("[OK] WS connection success")
      SeederChannel.join(%{})
    else
      error -> IO.puts("[ERROR] WS connection failure: #{inspect error}")
    end
  end
end
