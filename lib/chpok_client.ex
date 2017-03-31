defmodule ChpokClient do

  import ChpokSocket
  alias ChpokClient.ExchangeChannel
  @moduledoc """
  Documentation for ChpokClient.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ChpokClient.hello
      :world

  """

  @doc """
  Entry point for CLI
  """

  defstruct [
    name: "",
    src: "",
    dest: ""
  ]

  def test_run do
    with {:ok, socket} <- ChpokSocket.start_link,
      {:ok, channel} <- PhoenixChannelClient.channel(ExchangeChannel, socket: ChpokSocket, topic: "rooms:lobby")
    do
      ExchangeChannel.join(%{})
      ExchangeChannel.push("new:msg", %{msg: "FIRST MSG"})
    else
      error -> IO.inspect(error)
    end
    # TODO Establish WS connection
    # socket = Socket.Web.connect! "localhost", 4000, path: "/socket/websocket"
    #
    # main(
    #   socket,
    #   [dst: "/home/yz/Downloads/chpok_dest/", src: "/home/yz/Downloads/chpok_src/", name: "chpok_yz"]
    # )
  end

  def main(socket, args) do
    IO.puts("HELLO FROM MAIN")
    args
    # |> parse_args
    |> process
    |> validate
    |> prepare_dir_content
    |> get_file_stream
    |> send_chunks
  end

  def process([]) do
    IO.puts "Processing error: No arguments given"
  end

  def process(options) do
    options_map = Enum.into(options, %{})
    options_map
  end

  def validate(args) do
    if (File.exists?(args.src) || String.length(args.name) < 2) do
      args
    else
      IO.puts("Validation error: Wrong configuration")
    end
  end

  @doc """
  Example response:
  [
    %{path: "file.png", dir: false},
    %{path: "images", dir: true}
  ]
  """
  def prepare_dir_content(options_map) do
    src = options_map.src
    with {:ok, paths} = File.ls(src) do
      paths
      |> Enum.map(fn(i) -> %{dir: File.dir?(src <> i), path: i}  end)
    else
      error -> IO.puts("Error: #{inspect error}")
    end
  end

  @doc """
  Encode files into binary format and send over WebSocket
  """
  def get_file_stream(dir_content) do
    IO.puts("SENDING DIR CONTENT")
    "/home/yz/Downloads/chpok_src/1.jpg"
    |> File.stream!([],2024)
  end

  def send_chunks(file_stream) do
    # Send each chunk.
    # Server send inform if any error happens during sending chunk to opposite client.
    file_stream
    |> Enum.take(12)
    |> Stream.map(fn(chunk) ->
      # Base64 encode chunk
      # Send chunk
    end)
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [name: :string, src: :string, dest: :string]
    )
    options
  end

  def hello do
    :world
  end
end
