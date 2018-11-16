# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ex_wire,
  p2p_version: 0x04,
  protocol_version: 63,
  # ropsten
  network_id: 3,
  caps: [{"eth", 62}, {"eth", 63}],
  chain: :ropsten,
  # TODO: This should be set and stored in a file
  private_key: :random,
  bootnodes: :from_chain,
  # Number of peer advertisements before we trust a block
  commitment_count: 1,
  discovery: true,
  node_discovery: [
    network_adapter: {ExWire.Adapter.UDP, NetworkClient},
    kademlia_process_name: KademliaState,
    supervisor_name: ExWire.NodeDiscoverySupervisor,
    port: 30_304
  ],
  db_root:
    apply(
      fn ->
        if String.contains?(System.cwd!(), "apps") do
          Path.join([System.cwd!(), "/../../", "db"])
        else
          Path.join([System.cwd!(), "/db"])
        end
      end,
      []
    ),
  mana_version:
    apply(
      fn ->
        if String.contains?(System.cwd!(), "apps") do
          String.trim(File.read!(Path.join(["../../", "MANA_VERSION"])))
        else
          String.trim(File.read!(Path.join([System.cwd!(), "MANA_VERSION"])))
        end
      end,
      []
    )

config :ex_wire, :environment, Mix.env()
import_config "#{Mix.env()}.exs"
