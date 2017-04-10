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
    Sender.start_link(leacher)

    {:noreply, state}
  end

  def handle_in("ack:" <> path, _, state) do
    send Sender, {:ack, path}
    {:noreply, state}
  end

  def handle_reply({:ok, :join, _resp, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:new_msg_handled, "seeders:" <> _name, _resp, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:timeout, :join, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:timeout, "new:" <> path, _ref}, state) do
    IO.puts("Request for acknowledgement timed out")
    {:noreply, state}
  end

  def handle_close(_reason, state) do
    :timer.send_after(5000, {:rejoin, state})
    {:noreply}
  end
end
