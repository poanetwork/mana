defmodule JSONRPC2.Response.ReceiptTest do
  use ExUnit.Case, async: true

  alias JSONRPC2.Response.Receipt
  alias JSONRPC2.TestFactory

  describe "new/4" do
    test "creates response receipt from internal block for contract creation transaction" do
      transaction = TestFactory.build(:transaction)
      block = TestFactory.build(:block, transactions: [transaction])
      receipt = TestFactory.build(:receipt)

      response_receipt = Receipt.new(receipt, transaction, block)

      assert response_receipt == %JSONRPC2.Response.Receipt{
               blockHash: "0x0000000000000000000000000000000000000000000000000000000000000010",
               blockNumber: "0x01",
               contractAddress: "0x2e07fda729826779d050aa629355211735ce350d",
               cumulativeGasUsed: "0x03e8",
               from: "0x619f56e8bed07fe196c0dbc41b52e2bc64817b3a",
               gasUsed: "0x03e8",
               logs: [],
               logsBloom:
                 "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
               root: nil,
               status: "0x01",
               to: "0x",
               transactionHash:
                 "0x7f71d14c13c402ce13c6f063b83e085f097a878e33163d6146cece277936531b",
               transactionIndex: "0x00"
             }
    end

    test "creates response receipt from internal block for message call transaction" do
      transaction = TestFactory.build(:transaction, to: <<0x100::160>>, data: "contract creation")
      block = TestFactory.build(:block, transactions: [transaction])
      receipt = TestFactory.build(:receipt)

      response_receipt = Receipt.new(receipt, transaction, block)

      assert response_receipt == %Receipt{
               blockHash: "0x0000000000000000000000000000000000000000000000000000000000000010",
               blockNumber: "0x01",
               cumulativeGasUsed: "0x03e8",
               gasUsed: "0x03e8",
               logs: [],
               logsBloom:
                 "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
               root: nil,
               status: "0x01",
               transactionIndex: "0x00",
               contractAddress: nil,
               from: "0xf029c9a86c67aa8c77424e3f278b36eaa3754a20",
               to: "0x0000000000000000000000000000000000000100",
               transactionHash:
                 "0xb33cd4e38a774e1abcef0d18e357140c5a55717d74b9349c119da6608a5c21e2"
             }
    end
  end
end
