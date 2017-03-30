defmodule ChpokClient.ExchangeChannel do
  use PhoenixChannelClient

  def handle_in("new_msg", payload, state) do
    {:noreply, state}
  end

  def handle_reply({:ok, "new_msg", resp, _ref}, state) do
    {:noreply, state}
  end
  def handle_reply({:error, "new_msg", resp, _ref}, state) do
    {:noreply, state}
  end
  def handle_reply({:timeout, "new_msg", _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:timeout, :join, _ref}, state) do
    {:noreply, state}
  end

  def handle_close(reason, state) do
    :timer.send_after(5000, {:rejoin, state})
    {:noreply}
  end
end
