# ChpokClient

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `chpok_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:chpok_client, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/chpok_client](https://hexdocs.pm/chpok_client).


Server
sudo docker-compose up
sudo docker-compose build

## Run Seeder
sudo docker run -v /home/yz/Downloads/chpok_src/:/dir --env NAME=seed client2

## Run Leacher
sudo docker run -v /home/yz/Downloads/chpok_dst/:/dir --env NAME=ranom_leach --env LEACHER=true client2
