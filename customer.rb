require_relative 'helpers'
class Customer
include Helpers
 attr_accessor :account, :password, :name, :balance

 def initialize(account = " ", password = " " , name= " ", balance= " ")
  @accont = account
  @password = password
  @name = name
  @balance = balance
 end

 def get_account
   puts "Please Enter Your Account Number: "
   acc = gets.chomp
   if is_integer?(acc)
     account = acc.to_i
   else
     puts "ERROR: ACCOUNT NUMBER MUST BE AN INTEGER. PLEASE ENTER A DIFFERENT ACCOUNT NUMBER:"
     get_account
   end
 end

 def existing_account?(config, account)
   config['accounts'].has_key?(account)
 end

 def get_password
   puts "Please Enter Your Password: "
   pass = gets
   pasword = pass.chomp
 end

 def verified_password?(config, account, password)
   config['accounts'][account]['password'] == password
 end

 def get_name(config, account)
   name = config['accounts'][account]['name']
 end

 def get_balance(config, account)
   balance = config['accounts'][account]['balance']
 end

end
