defmodule ChpokClient.Seeder do

  import ClientSocket
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
      SeederChannel.join(%{})
    else
      error -> IO.inspect(error)
    end
  end
end
