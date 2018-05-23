# encoding: UTF-8
class Withdrawal < Transaction

 def sufficient_atm_balance?(atm)
   atm.balance >= @amount
 end

 def sufficient_customer_balance?(customer)
   customer.balance >= @amount
 end

 def can_be_composed?(atm)
   unpaid_amount = @amount
   atm.banknotes.each do |denomination, quantity|
     if unpaid_amount/denomination >= quantity
      unpaid_amount-= quantity*denomination
     else
       unpaid_amount-= (unpaid_amount/denomination)*denomination
     end
   end
   unpaid_amount == 0
 end

 def check_withdrawal(config, atm, customer)
   if !sufficient_customer_balance?(customer)
     puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
     check_amount
     check_withdrawal(config, atm, customer)
   elsif !sufficient_atm_balance?(atm)
     puts "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS $#{atm.balance}. PLEASE ENTER A DIFFERENT AMOUNT:"
     check_amount
     check_withdrawal(config, atm, customer)
   elsif !can_be_composed?(atm)
     puts "ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:"
     check_amount
     check_withdrawal(config, atm, customer)
   else
     complete(config, atm, customer)
     puts "Your New Balance is $#{customer.balance}"
   end
 end

 def complete(config, atm, customer)
   unpaid_amount = @amount
   atm.banknotes.each do |denomination, quantity|
     if unpaid_amount/denomination >= quantity
       unpaid_amount-= quantity*denomination
       atm.banknotes[denomination] = 0
     else
       atm.banknotes[denomination]-= unpaid_amount/denomination
       unpaid_amount-= (unpaid_amount/denomination)*denomination
     end
   end
   customer.balance-= @amount
   @amount = 0
   config['banknotes'] = atm.banknotes
   config['accounts'][customer.account]['balance'] = customer.balance
 end

end
