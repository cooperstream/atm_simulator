# encoding: UTF-8
require 'yaml'
require_relative 'customer'
require_relative 'transaction'


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



config = YAML.load_file(ARGV.first || 'config.yml')
start(config)
