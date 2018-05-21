# encoding: UTF-8
require 'yaml'
require_relative 'customer'
require_relative 'transaction'

class ATM
 attr_accessor :banknotes

 def initialize(banknotes= "")
  @banknotes = banknotes
 end

 def get_banknotes(config)
    banknotes = config['banknotes']
 end

 def balance
  balance = 0
  banknotes.each {|denomination, quantity| balance+= denomination*quantity}
  balance
 end

end

def start(config)
  atm = ATM.new()
  customer = Customer.new()
  transaction = Transaction.new()
  atm.banknotes = atm.get_banknotes(config)
  puts "Please Enter Your Account Number: "
  customer.account = customer.get_account
   if customer.existing_account?(config)
     puts "Please Enter Your Password: "
     customer.password = customer.get_password
     if customer.verified_password?(config)
       customer.name = customer.get_name(config)
       customer.balance = customer.get_balance(config)
       puts "Hello, #{customer.name}!"
       menu(config, atm, customer, transaction)
     else
       puts "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH"
       start(config)
     end
   else
     puts "ERROR: ACCOUNT NUMBER NOT FOUND"
     start(config)
   end
 end

def menu(config, atm, customer, transaction)
   puts "Please Choose From the Following Options:
   1. Display Balance
   2. Withdraw
   3. Log Out"
   choise = gets.to_i
    case(choise)
       when(1)
          puts "Your Current Balance is $#{customer.balance}"
          menu(config, atm, customer, transaction)
       when(2)
          transaction = Withdrawal.new()
          puts "Enter Amount You Wish to Withdraw: "
          withdrawl_check(config, atm, customer, transaction)
       when(3)
          puts "#{customer.name}, Thank You For Using Our ATM. Good-Bye!"
          start(config)
       else
          puts "ERROR"
          menu(config, atm, customer, transaction)
       end
end

def withdrawl_check(config, atm, customer, transaction)
  transaction.amount = transaction.get_amount
  if !transaction.is_positive?
    puts "ERROR: THE AMOUNT MUST BE POSITIVE!! PLEASE ENTER A DIFFERENT AMOUNT:"
    withdrawl_check(config, atm, customer, transaction)
  elsif !transaction.sufficient_customer_balance?(customer)
    puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
    withdrawl_check(config, atm, customer, transaction)
  elsif !transaction.sufficient_atm_balance?(atm)
    puts "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS $#{atm.balance}. PLEASE ENTER A DIFFERENT AMOUNT:"
    withdrawl_check(config, atm, customer, transaction)
  elsif !transaction.can_be_composed?(atm)
    puts "ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:"
    withdrawl_check(config, atm, customer, transaction)
  else
    transaction.complete(config, atm, customer)
    transaction = Transaction.new()
    puts "Your New Balance is $#{customer.balance}"
    menu(config, atm, customer, transaction)
  end
end


config = YAML.load_file(ARGV.first || 'config.yml')
start(config)
