defmodule ExWire.Kademlia do
  @moduledoc """
  Handles Kademlia algorithm state.
  """

  alias ExWire.Handler.Params
  alias ExWire.Kademlia.{Node, RoutingTable, Server}
  alias ExWire.Message.{FindNeighbours, Neighbours, Pong}
  alias ExWire.Struct.Endpoint

  @server Server.name()
  @spec server() :: Server.name()
  def server, do: @server

  @doc """
  Adds new node to routing table.
  """
  @spec refresh_node(GenServer.server(), Node.t()) :: :ok
  def refresh_node(server \\ Server.name(), peer = %Node{}) do
    GenServer.cast(server, {:refresh_node, peer})
  end

  @doc """
  Handles pong message (adds a node to routing table etc).
  """
  @spec handle_pong(Pong.t(), Keyword.t()) :: :ok
  def handle_pong(server \\ Server.name(), pong = %Pong{}) do
    GenServer.cast(server, {:handle_pong, pong})
  end

  @doc """
  Handles ping message (by adding a node to routing table etc).
  """
  @spec handle_ping(Params.t(), Keyword.t()) :: :ok
  def handle_ping(server \\ Server.name(), params = %Params{}) do
    GenServer.cast(server, {:handle_ping, params})
  end

  @doc """
  Sends ping to a node saving it to expected pongs.
  """
  @spec ping(Node.t(), Keyword.t()) :: :ok
  def ping(server \\ Server.name(), node = %Node{}) do
    GenServer.cast(server, {:ping, node})
  end

  @doc """
  Returns current routing table.
  """
  @spec routing_table() :: RoutingTable.t()
  def routing_table(server \\ Server.name()) do
    GenServer.call(server, :routing_table)
  end

  @doc """
  Returns neighbours of specified node.
  """
  @spec neighbours(FindNeighbours.t(), Endpoint.t(), Keyword.t()) :: [Node.t()]
  def neighbours(server \\ Server.name(), find_neighbours, endpoint) do
    GenServer.call(server, {:neighbours, find_neighbours, endpoint})
  end

  @doc """
  Receives neighbours request and ping each of them if request is not expired.
  """
  @spec handle_neighbours(Neighbours.t(), Keyword.t()) :: :ok
  def handle_neighbours(server \\ Server.name(), neighbours) do
    GenServer.cast(server, {:handle_neighbours, neighbours})
  end
end
