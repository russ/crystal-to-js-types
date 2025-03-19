class User
  property username : String
  property email : String
  property phone_number : String? = nil
  property birth_date : Time? = nil
  property preferences : Hash(String, String)? = nil
  property wishlist : Array(String | Int32)? = nil

  def initialize(
    @username : String,
    @email : String,
    @phone_number : String? = nil,
    @birth_date : Time? = nil,
    @preferences : Hash(String, String)? = nil,
    @wishlist : Array(String | Int32)? = nil,
  )
  end
end
