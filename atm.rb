# encoding: UTF-8
require 'yaml'

def start(config)
  atm = ATM.new()
  customer = Customer.new()
  transaction = Transaction.new
  atm.banknotes = atm.get_banknotes(config)
  customer.account = customer.get_account
   if customer.existing_account?(config, customer.account)
     customer.password = customer.get_password
     if customer.verified_password?(config, customer.account, customer.password)
       customer.name = customer.get_name(config, customer.account)
       customer.balance = customer.get_balance(config, customer.account)
       puts "Hello, #{customer.name}!"
       atm.menu(config, customer, transaction)
     else
       puts "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH"
       start(config)
     end
   else
     puts "ERROR: ACCOUNT NUMBER NOT FOUND"
     start(config)
   end
 end

class String
   def is_integer?
     self.to_i.to_s == self
   end
end

class ATM

 attr_accessor :banknotes

 def initialize(banknotes= "")
  @banknotes = banknotes
 end

 def get_banknotes(config)
   banknotes = config['banknotes']
 end

 def balance
  denomination = banknotes.keys
  quantity = banknotes.values
  balance = 0
    (0..denomination.length-1).each do |i|
      balance+= denomination[i]*quantity[i]
     end
  balance
 end

 def menu(config,customer, transaction)
   puts "Please Choose From the Following Options:
   1. Display Balance
   2. Withdraw
   3. Log Out"
   choise = gets.to_i
    case(choise)
       when(1)
          puts "Your Current Balance is $#{customer.balance}"
          menu(config,customer, transaction)
       when(2)
          puts "Enter Amount You Wish to Withdraw: "
          transaction.check(config, self, customer)
       when(3)
          puts "#{customer.name}, Thank You For Using Our ATM. Good-Bye!"
          start(config)
       else
          puts "ERROR"
          menu(config,customer, transaction)
    end
  end

end

class Customer

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
   if acc.is_integer?
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

class Transaction

 def get_amount
   am = gets.chomp
   if (am.is_integer? and am.to_i >= 0)
     amount = am.to_i
   else
     puts "ERROR: AMOUNT MUST BE AN INTEGER AND POSITIVE. PLEASE ENTER A DIFFERENT AMOUNT:"
     get_amount
   end
 end

 def sufficient_atm_balance?(amount, atm)
   atm.balance >= amount
 end

 def sufficient_customer_balance?(amount, customer)
   customer.balance >= amount
 end

 def can_be_composed?(amount, atm)
   denomination = atm.banknotes.keys
   quantity = atm.banknotes.values
   unpaid_amount = amount
     (0..denomination.length-1).each do |i|
       issued_banknotes = (unpaid_amount-unpaid_amount%denomination[i])/denomination[i]
        if issued_banknotes <= quantity[i]
          unpaid_amount-= denomination[i]*issued_banknotes
        else
          unpaid_amount-= denomination[i]*quantity[i]
        end
      end
   unpaid_amount == 0
 end

 def check(config, atm, customer)
   amount = get_amount
     if !sufficient_atm_balance?(amount, atm)
       puts "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS $#{atm.balance}. PLEASE ENTER A DIFFERENT AMOUNT:"
       check(config, atm, customer)
     else
        if !sufficient_customer_balance?(amount, customer)
          puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
          check(config, atm, customer)
        else
           if !can_be_composed?(amount, atm)
              puts "ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:"
              check(config, atm, customer)
           else
              withdrawal(config, amount, atm, customer)
              puts "Your New Balance is $#{customer.balance}"
              atm.menu(config,customer, self)
           end
        end
     end
 end

 def withdrawal(config, amount, atm, customer)
   denomination = atm.banknotes.keys
   quantity = atm.banknotes.values
   unpaid_amount = amount
     (0..denomination.length-1).each do |i|
       issued_banknotes = (unpaid_amount - unpaid_amount%denomination[i])/denomination[i]
       if issued_banknotes <= quantity[i]
          unpaid_amount-= denomination[i]*issued_banknotes
          quantity[i]-= issued_banknotes
       else
          unpaid_amount-= denomination[i]*quantity[i]
          quantity[i] = 0
       end
     end
  (0..denomination.length-1).each do |i|
   atm.banknotes[ denomination[i] ] = quantity[i]
   end
   customer.balance-= amount
   config['banknotes'] = atm.banknotes
   config['accounts'][customer.account]['balance'] = customer.balance
 end

end

config = YAML.load_file(ARGV.first || 'config.yml')
start(config)
