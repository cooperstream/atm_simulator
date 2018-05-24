# encoding: UTF-8
require 'yaml'
require_relative './lib/atm'
require_relative './lib/customer'
require_relative './lib/transaction'
require_relative './lib/withdrawal'

def start(config)
 atm = ATM.new(config['banknotes'])
 customer = Customer.new()
 transaction = Transaction.new()
 customer.verification(config)
 menu(config, atm, customer, transaction)
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
    transaction.check_amount
    transaction.check_withdrawal(config, atm, customer)
    transaction.complete(config, atm, customer)
    puts "Your New Balance is $#{customer.balance}"
    transaction = Transaction.new()
    menu(config, atm, customer, transaction)
  when(3)
    puts "#{customer.name}, Thank You For Using Our ATM. Good-Bye!"
    start(config)
  else
    puts "ERROR"
    menu(config, atm, customer, transaction)
  end
end

config = YAML.load_file(ARGV.first || 'config.yml')
start(config)
