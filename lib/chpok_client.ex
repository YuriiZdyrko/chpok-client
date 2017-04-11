defmodule ChpokClient do

  @moduledoc """
  Starts Leacher or Seeder client,
  depending on arguments.
  """

  use GenServer

  alias ChpokClient.Leacher
  alias ChpokClient.Seeder

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(_) do
    options = %{
      leacher?: Application.get_env(:chpok_client, :leacher?),
      dir: Application.get_env(:chpok_client, :dir),
      name: Application.get_env(:chpok_client, :name)
    }

    with :ok <- validate_dir(options),
      :ok <- validate_name(options) do
      IO.puts("[INFO] Initialization with arguments #{inspect options}")
      start_client(options)
    else
      error ->
        IO.puts("[ERROR] Initialization failed: #{inspect error}")
    end
    {:ok, []}
  end

  def validate_name(%{name: name}) do
    if (!name || String.length(name) < 2) do
      {:error, "Invalid name argument: #{inspect name}"}
    else
      :ok
    end
  end

  def validate_dir(%{dir: dir}) do
    if (!dir || !File.dir?(dir)) do
      {:error, "Invalid dir argument: #{inspect dir}"}
    else
      :ok
    end
  end

  @doc """
  Client is lauched in Leacher or Seeder mode.
  """
  def start_client(%{leacher?: true} = _args) do
    IO.puts("[INFO] Initializing in Leacher mode")
    Leacher.run()
  end

  def start_client(_args) do
    IO.puts("[INFO] Initializing in Seeder mode")
    Seeder.run()
  end

  def run_seeder do
    Application.put_env(:chpok_client, :dir, "/home/yz/Downloads/chpok_src/")
    Application.put_env(:chpok_client, :name, "Seeder1")
    ChpokClient.Seeder.run()
  end

  def run_leacher do
    Application.put_env(:chpok_client, :dir, "/home/yz/Downloads/chpok_dst/")
    Application.put_env(:chpok_client, :name, "Leacher1")
    ChpokClient.Leacher.run()
  end
end
