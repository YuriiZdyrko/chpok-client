defmodule ChpokClient.Leacher do

  @moduledoc """
  Use this module to run Leacher instance.
  To work, it requires running Proxy with at least one connected Seeder.
  """
  alias ChpokClient.LeacherChannel
  alias ChpokClient.Leacher.Fetcher

  def run do
    name = Application.get_env(:chpok_client, :name)
    with  {:ok, _socket} <- ClientSocket.start_link,
          {:ok, _channel} <- PhoenixChannelClient.channel(
            LeacherChannel,
            socket: ClientSocket,
            topic: "leachers:#{name}"
          ),
          {:ok, seeders} <- fetch_seeders(),
          {:ok, seeder} <- pick_seeder(seeders) do
      LeacherChannel.join(%{})
      fetch_files(seeder)
    else
      {:error, error} -> IO.puts("[ERROR] WS connection failure: #{inspect error}")
    end
  end

  def fetch_seeders do
    seeders_url = Application.get_env(:chpok_client, :chpok_server) <> "/seeders"

    try do
      HTTPotion.get(seeders_url)
      |> Map.get(:body)
      |> Poison.decode
    catch
      error -> {:error, error}
    end
  end

  defp pick_seeder(seeders) do
    l = length(seeders)
    cond do
      l == 0 ->
        {:error, "No seeders available"}
      l == 1 ->
        {:ok, List.first(seeders)}
      l > 1 ->
        prompt_to_pick_seeder(seeders)
    end
  end

  defp prompt_to_pick_seeder(seeders) do
    seeder = IO.gets("Type seeder name to fetch files: #{inspect seeders} \n")
    |> String.trim

    if (Enum.member?(seeders, seeder)) do
      {:ok, seeder}
    else
      IO.puts("Please choose seeder from list!")
      prompt_to_pick_seeder(seeders)
    end
  end

  defp fetch_files(seeder) do
    Fetcher.run(seeder)
  end
end
