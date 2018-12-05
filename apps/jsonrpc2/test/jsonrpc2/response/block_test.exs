defmodule JSONRPC2.Response.BlockTest do
  use ExUnit.Case, async: true

  alias JSONRPC2.Response.Block
  alias JSONRPC2.TestFactory

  describe "new/1" do
    test "creates response block from internal block" do
      internal_block = TestFactory.build(:block)

      response_block = Block.new(internal_block)

      assert response_block == %Block{
               difficulty: 1,
               extraData: "",
               gasLimit: 0,
               gasUsed: 0,
               hash: "0x0000000000000000000000000000000000000000000000000000000000000010",
               logsBloom:
                 "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
               miner: "0x0000000000000000000000000000000000000010",
               nonce: "0x0000000000000000",
               number: 1,
               parentHash: "0x0000000000000000000000000000000000000000000000000000000000000010",
               receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
               sha3Uncles: nil,
               size: nil,
               stateRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
               timestamp: 1,
               totalDifficulty: nil,
               transactions: [],
               transactionsRoot:
                 "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
               uncles: []
             }
    end

    test "correctly encodes to json" do
      internal_block = TestFactory.build(:block)

      json_block =
        internal_block
        |> Block.new()
        |> Jason.encode!()

      assert json_block ==
               "{\"difficulty\":1,\"extraData\":\"\",\"gasLimit\":0,\"gasUsed\":0,\"hash\":\"0x0000000000000000000000000000000000000000000000000000000000000010\",\"logsBloom\":\"0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000\",\"miner\":\"0x0000000000000000000000000000000000000010\",\"nonce\":\"0x0000000000000000\",\"number\":1,\"parentHash\":\"0x0000000000000000000000000000000000000000000000000000000000000010\",\"receiptsRoot\":\"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421\",\"sha3Uncles\":null,\"size\":null,\"stateRoot\":\"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421\",\"timestamp\":1,\"totalDifficulty\":null,\"transactions\":[],\"transactionsRoot\":\"0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421\",\"uncles\":[]}"
    end
  end
end
