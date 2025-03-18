@[TypeScriptExport::Serializer]
class UserSerializer < BaseSerializer
  def initialize(@user : User)
  end

  def render
    {
      username:     username,
      email:        email,
      phone_number: phone_number,
      birth_date:   birth_date,
      bank_account: bank_account,
      friends:      friends,
    }
  end

  @[TypeScriptExport::Field]
  def username : String
    @user.username
  end

  @[TypeScriptExport::Field]
  def email : String
    @user.email
  end

  @[TypeScriptExport::Field]
  def phone_number : String?
    @user.phone_number
  end

  @[TypeScriptExport::Field]
  def birth_date : Time?
    @user.birth_date
  end

  @[TypeScriptExport::Field]
  def bank_account : BankAccountSerializer
    BankAccountSerializer.new(
      BankAccount.new(balance: 100)
    )
  end

  @[TypeScriptExport::Field]
  def friends : Array(UserSerializer)
    [
      UserSerializer.new(
        User.new(balance: 100)
      )
    ]
  end
end
