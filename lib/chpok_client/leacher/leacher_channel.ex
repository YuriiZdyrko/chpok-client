defmodule ChpokClient.LeacherChannel do
  use PhoenixChannelClient

  def handle_in("join", _resp, state) do
    {:noreply, state}
  end

  @doc """
  Handle Seeder's response
  """
  def handle_in("new:msg", %{"msg" => msg, "dst_path" => dst_path}, state) do

    IO.puts("Handling 'new:msg' in leacher")
    dir = Application.get_env(:chpok_client, :dir)

    {:ok, decoded_msg} = Base.decode64(msg)
    case File.write(dir <> dst_path, decoded_msg) do
      :ok -> IO.puts("File #{dst_path} saved")
      {:error, reason} -> IO.puts("FileSaver error: #{reason}")
    end
    {:noreply, state}
  end

  def handle_reply({:ok, :join, _resp, _mysterious_id}, state) do
    {:noreply, state}
  end

  def handle_reply({:timeout, :join, _ref}, state) do
    {:noreply, state}
  end

  # TODO: probably should be removed
  def handle_reply({:timeout, "leaching_request", _ref}, state) do
    {:noreply, state}
  end

  def handle_close(_reason, state) do
    :timer.send_after(5000, {:rejoin, state})
    {:noreply}
  end
end
