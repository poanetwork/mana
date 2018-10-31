defmodule Blockchain.Genesis do
  @moduledoc """
  Defines functions for genesis block generation.
  """

  alias Block.Header
  alias Blockchain.{Account, Block, Chain}
  alias MerklePatriciaTree.TrieStorage

  @type seal_config :: %{
          mix_hash: binary(),
          nonce: binary()
        }

  @type seal :: %{String.t() => seal_config()}

  @type t :: %{
          seal: nil | seal(),
          difficulty: integer(),
          author: EVM.address(),
          timestamp: integer(),
          parent_hash: EVM.hash(),
          extra_data: binary(),
          gas_limit: EVM.Gas.t()
        }

  @doc """
  Creates a genesis block for a given chain.

  The genesis block is specified by parameters in the
  chain itself. Thus, this function takes no additional
  parameters.

  ## Examples

      iex> trie = MerklePatriciaTree.Test.random_ets_db() |> MerklePatriciaTree.Trie.new()
      iex> chain = Blockchain.Chain.load_chain(:ropsten)
      iex> {block, _state} = Blockchain.Genesis.create_block(chain, trie)
      iex> block
      %Blockchain.Block{
        header: %Block.Header{
          number: 0,
          timestamp: 0,
          beneficiary: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
          difficulty: 1048576,
          extra_data: "55555555555555555555555555555555",
          gas_limit: 16777216,
          parent_hash: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
          state_root: <<232, 107, 69, 139, 178, 253, 233, 218, 130, 174, 216, 128, 173, 120, 27, 24, 193, 116, 237, 198, 52, 187, 160, 193, 55, 110, 174, 93, 47, 62, 189, 214>>,
          transactions_root: <<86, 232, 31, 23, 27, 204, 85, 166, 255, 131, 69, 230, 146, 192, 248, 110, 91, 72, 224, 27, 153, 108, 173, 192, 1, 98, 47, 181, 227, 99, 180, 33>>,
          receipts_root: <<86, 232, 31, 23, 27, 204, 85, 166, 255, 131, 69, 230, 146, 192, 248, 110, 91, 72, 224, 27, 153, 108, 173, 192, 1, 98, 47, 181, 227, 99, 180, 33>>,
          ommers_hash: <<29, 204, 77, 232, 222, 199, 93, 122, 171, 133, 181, 103, 182, 204, 212, 26, 211, 18, 69, 27, 148, 138, 116, 19, 240, 161, 66, 253, 64, 212, 147, 71>>,
          mix_hash: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
          nonce: <<0, 0, 0, 0, 0, 0, 0, 66>>
        },
        ommers: [],
        transactions: []
      }

      # TODO: Add test case with initial storage
  """
  @spec create_block(Chain.t(), TrieStorage.t()) :: Block.t()
  def create_block(chain, trie) do
    header = create_header(chain.genesis)
    block = %Block{header: header}
    accounts = Enum.into(chain.accounts, [])

    state =
      Enum.reduce(accounts, trie, fn {address, account_map}, trie_acc ->
        if is_nil(account_map[:balance]) do
          trie_acc
        else
          {account, trie_acc} = create_account(trie_acc, address, account_map)
          Account.put_account(trie_acc, address, account)
        end
      end)

    root_hash = TrieStorage.root_hash(state)
    header = %{header | state_root: root_hash}

    {%{block | header: header}, state}
  end

  @doc """
  Creates a genesis block header.
  """
  @spec create_header(t) :: Header.t()
  def create_header(genesis) do
    %Header{
      number: 0,
      parent_hash: genesis[:parent_hash],
      timestamp: genesis[:timestamp],
      extra_data: genesis[:extra_data],
      beneficiary: genesis[:author],
      difficulty: genesis[:difficulty],
      gas_limit: genesis[:gas_limit],
      mix_hash: genesis[:seal][:mix_hash],
      nonce: genesis[:seal][:nonce]
    }
  end

  @spec create_account(TrieStorage.t(), EVM.address(), map()) :: Account.t()
  def create_account(trie, address, account_map) do
    storage =
      if account_map[:storage_root],
        do: TrieStorage.set_root_hash(trie, account_map[:storage_root]),
        else: trie

    storage =
      if account_map[:storage] do
        Enum.reduce(account_map[:storage], storage, fn {key, value}, trie ->
          Account.put_storage(trie, address, key, value)
        end)
      else
        storage
      end

    {%Account{
       nonce: account_map[:nonce] || 0,
       balance: account_map[:balance],
       storage_root: TrieStorage.root_hash(storage)
     }, storage}
  end

  @doc """
  Returns whether or not a block is a genesis block, based on block number.

  ## Examples

      iex> Blockchain.Genesis.is_genesis_block?(%Blockchain.Block{header: %Block.Header{number: 0}})
      true

      iex> Blockchain.Genesis.is_genesis_block?(%Blockchain.Block{header: %Block.Header{number: 1}})
      false
  """
  @spec is_genesis_block?(Block.t()) :: boolean()
  def is_genesis_block?(block), do: block.header.number == 0
end
