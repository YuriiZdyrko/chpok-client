defmodule ChpokClient.ExchangeChannel do
  use PhoenixChannelClient

  def handle_in("new_msg", payload, state) do
    {:noreply, state}
  end

  def handle_in("user:entered", resp, state) do
    {:noreply, state}
  end

  def handle_in("new:msg", resp, state) do
    {:noreply, state}
  end

  def handle_in("join", resp, state) do
    {:noreply, state}
  end

  def handle_reply({:ok, :join, resp, _mysterious_id}, state) do
    {:noreply, state}
  end




  # Mine

  def handle_reply({:ok, "rooms:lobby", resp, _mysterious_id}, state) do
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
