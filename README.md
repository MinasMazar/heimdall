# Heimdall

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `heimdall` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:heimdall, "~> 0.1.0"}
  ]
end
```

## Usage

Start a process and register it via

```elixir
Registry.register(Heimdall.Registry, Heimdall, url_regex)
```

or via

```elixir
Heimdall.subscribe_handler(url_regex)
```

Url regex will match against every event or message sent by the client.

## Doc

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/heimdall>.

