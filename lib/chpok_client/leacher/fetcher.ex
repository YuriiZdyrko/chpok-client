defmodule ChpokClient.Leacher.Fetcher do

  import IEx
  alias ChpokClient.LeacherChannel

  def run(seeder) do
    leacher = Application.get_env(:chpok_client, :name)
    LeacherChannel.push("leaching_request", %{seeder: seeder, leacher: leacher})
  end
end
