# encoding: UTF-8
class Customer

 attr_accessor :account, :password, :name, :balance

 def initialize(account = " ", password = " " , name= " ", balance= " ")
  @accont = account
  @password = password
  @name = name
  @balance = balance
 end

 def get_account
   acc = gets.chomp
   account = acc.to_i
 end

 def existing_account?(config)
   config['accounts'].has_key?(account)
 end

 def get_password
   pass = gets
   pasword = pass.chomp
 end

 def verified_password?(config)
   config['accounts'][account]['password'] == password
 end

 def get_name(config)
   name = config['accounts'][account]['name']
 end

 def get_balance(config)
   balance = config['accounts'][account]['balance']
 end

end
