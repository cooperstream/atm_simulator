require_relative 'helpers'
class Transaction
  include Helpers
 def get_amount
   am = gets.chomp
   if (is_integer?(am) and am.to_i >= 0)
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
     if !sufficient_customer_balance?(amount, customer)
       puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
       check(config, atm, customer)
     else
        if !sufficient_atm_balance?(amount, atm)
          puts "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS $#{atm.balance}. PLEASE ENTER A DIFFERENT AMOUNT:"
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
