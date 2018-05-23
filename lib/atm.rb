# encoding: UTF-8
class ATM
  
 attr_accessor :banknotes

 def initialize(banknotes= "")
  @banknotes = banknotes
 end

 def balance
  balance = 0
  banknotes.each {|denomination, quantity| balance+= denomination*quantity}
  balance
 end

 def start(config)
  customer = Customer.new()
  transaction = Transaction.new()
  customer.check_account(config)
  menu(config, customer, transaction)
 end

 def menu(config, customer, transaction)
   puts "Please Choose From the Following Options:
   1. Display Balance
   2. Withdraw
   3. Log Out"
   choise = gets.to_i
   case(choise)
   when(1)
     puts "Your Current Balance is $#{customer.balance}"
     menu(config, customer, transaction)
   when(2)
     transaction = Withdrawal.new()
     puts "Enter Amount You Wish to Withdraw: "
     transaction.check_amount
     transaction.check_withdrawal(config, self, customer)
     transaction.complete(config, self, customer)
     transaction = Transaction.new()
     menu(config, customer, transaction)
   when(3)
     puts "#{customer.name}, Thank You For Using Our ATM. Good-Bye!"
     start(config)
   else
     puts "ERROR"
     menu(config, customer, transaction)
   end
 end

end
