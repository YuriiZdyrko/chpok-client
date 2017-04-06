defmodule ChpokClient do

  @moduledoc """
  Callback module to start Leacher or Seeder client,
  depending on command-line arguments.
  """

  alias ChpokClient.Leacher
  alias ChpokClient.Seeder

  @doc """
  Entry point for CLI
  Example of arguments: --leacher name="Leacher Name" dir="/home/yz/Downloads/chpok_dst/"
  """
  def main(args) do
    with {:ok, options} <- parse_args(args),
      {:ok, options} <- validate(options) do
      put_env_variables(options)
      start_client(options)
    else
      error -> IO.puts("Error during client initialization: #{inspect error}")
    end
  end

  def validate(args) do
    if (File.dir?(args.dir) || String.length(args.name) < 2) do
      {:ok, args}
    else
      {:error, "Invalid command line arguments"}
    end
  end

  defp parse_args(args) do
    try do
      {options, _, _} = OptionParser.parse!(args,
        # Use --leacher switch, to run Leacher client. Seeder is default mode.
        # Dir will act as a destination folder for Leacher, and source for Seeder
        switches: [leacher: :boolean, name: :string, dir: :string]
      )
      {:ok, Enum.into(options, %{})}
    catch
      error ->
        {:error, "Unable to parse command line arguments. #{inspect error}"}
    end
  end

  @doc """
  Put :name and :dir variables
  """
  def put_env_variables(options) do
    for {key, value} <- options do
      Application.put_env(:chpok_client, key, value)
    end
  end

  @doc """
  Client is lauched in Leacher or Seeder mode.
  """
  def start_client(%{leacher: true} = _args) do
    Leacher.run()
  end

  def start_client(_args) do
    Seeder.run()
  end

  # TODO: Remove in future. Only for testing

  def run_seeder_main do
    with {:ok, options} <- validate(%{dir: "/home/yz/Downloads/chpok_src/", name: "Seeder1"}) do
      put_env_variables(options)
      start_client(options)
    else
      error -> IO.puts("Error during client initialization: #{inspect error}")
    end
  end

  def run_leacher_main do
    with {:ok, options} <- validate(%{leacher: true, dir: "/home/yz/Downloads/chpok_dst/", name: "Seeder1"}) do
      put_env_variables(options)
      start_client(options)
    else
      error -> IO.puts("Error during client initialization: #{inspect error}")
    end
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
