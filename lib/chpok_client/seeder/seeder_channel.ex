defmodule ChpokClient.SeederChannel do
  use PhoenixChannelClient
  alias ChpokClient.Seeder.Sender

  def handle_in("join", _resp, state) do
    {:noreply, state}
  end

  @doc """
  Handle Leaching request
  """
  def handle_in("leaching_request", %{"leacher" => leacher}, state) do

    IO.puts("Leaching request from: #{leacher}")

    # Used spawn_link to avoid "Process called itself", when
    # Sender.run() invokes SeederChannel.push
    spawn(fn ->
      Sender.run(leacher)
    end)

    {:noreply, state}
  end

  def handle_reply({:ok, :join, _resp, _mysterious_id}, state) do
    {:noreply, state}
  end

  def handle_reply({:new_msg_handled, "seeders:" <> _name, _resp, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:timeout, :join, _ref}, state) do
    {:noreply, state}
  end

  def handle_close(_reason, state) do
    :timer.send_after(5000, {:rejoin, state})
    {:noreply}
  end
end
