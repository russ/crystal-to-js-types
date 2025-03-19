@[TypeScriptExport::Serializer]
class TransactionSerializer < BaseSerializer
  def initialize(@transaction : Transaction)
  end

  def render
    {
      amount: amount,
      memo: memo,
    }
  end

  @[TypeScriptExport::Field]
  def amount : Int32
    @transaction.amount
  end

  @[TypeScriptExport::Field]
  def memo : String?
    nil
  end
end
