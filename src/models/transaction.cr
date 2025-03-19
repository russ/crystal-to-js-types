class Transaction
  property amount : Int32 = 0
  property memo : String?

  def initialize(@amount : Int32 = 0, @memo : String? = nil)
  end
end
