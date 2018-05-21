# encoding: UTF-8
class Transaction

 attr_accessor :amount

 def initialize(amount= "")
    @amount = amount
 end

 def get_amount
   am = gets.chomp
   amount = am.to_i
 end

 def is_positive?
   amount >= 0
 end

end

class Withdrawal < Transaction

 def sufficient_atm_balance?(atm)
   atm.balance >= amount
 end

 def sufficient_customer_balance?(customer)
   customer.balance >= amount
 end

 def can_be_composed?(atm)
   unpaid_amount = amount
   atm.banknotes.each {|denomination, quantity|
     if unpaid_amount/denomination >= quantity
      unpaid_amount-= quantity*denomination
     else
       unpaid_amount-= (unpaid_amount/denomination)*denomination
     end}
   unpaid_amount == 0
 end

 def complete(config, atm, customer)
   unpaid_amount = amount
   atm.banknotes.each {|denomination, quantity|
     if unpaid_amount/denomination >= quantity
       unpaid_amount-= quantity*denomination
       atm.banknotes[denomination] = 0
     else
       atm.banknotes[denomination]-= unpaid_amount/denomination
       unpaid_amount-= (unpaid_amount/denomination)*denomination
     end}
   customer.balance-= amount
   config['banknotes'] = atm.banknotes
   config['accounts'][customer.account]['balance'] = customer.balance
 end

end
