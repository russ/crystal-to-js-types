@[TypeScriptExport::Serializer]
class BankAccountSerializer < BaseSerializer
  def initialize(@bank_account : BankAccount)
  end

  def render
    {
      balance: balance,
      transactions: transactions,
    }
  end

  @[TypeScriptExport::Field]
  def balance : Int32
    @bank_account.balance
  end

  @[TypeScriptExport::Field]
  def transactions : Array(TransactionSerializer)
    [] of TransactionSerializer
  end
end
