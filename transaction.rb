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

 def complete(config, atm, customer)
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
   amount = 0
 end

end
