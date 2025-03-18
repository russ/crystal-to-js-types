class User
  property username : String
  property email : String
  property phone_number : String?
  property birth_date : Time?

  def initialize(
    @username : String,
    @email : String,
    @phone_number : String?,
    @birth_date : Time?
  )
  end
end
