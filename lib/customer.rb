# encoding: UTF-8
class Customer

 attr_accessor :account, :password, :name, :balance

 def initialize(account = " ", password = " " , name= " ", balance= " ")
  @account = account
  @password = password
  @name = name
  @balance = balance
 end

 def verification(config)
   puts "Please Enter Your Account Number: "
   @account = gets.chomp
   if !is_4digital?
     puts "ERROR: ACCOUNT NUMBER MUST BE 4-DIGITAL"
     verification(config)
   else
     @account = @account.to_i
     if !existing_account?(config)
       puts "ERROR: ACCOUNT NUMBER NOT FOUND"
       verification(config)
     else
       check_password(config)
     end
   end
 end

 

 def is_4digital?
   /\A\d+\z/.match(@account) and @account.length == 4
 end

 def existing_account?(config)
   config['accounts'].has_key?(@account)
 end

 def verified_password?(config)
   config['accounts'][@account]['password'] == @password
 end

 def check_password(config)
   puts "Please Enter Your Password: "
   @password = gets.chomp
   if !verified_password?(config)
     puts "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH"
     verification(config)
   else
     @name = config['accounts'][@account]['name']
     @balance = config['accounts'][@account]['balance']
   end
 end

end
