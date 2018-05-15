class ATM
 def start(config)
    customer=Customer.new
    account = customer.get_account
    if customer.existing_account?(config,account)
      password = customer.get_password
      if customer.verified_password?(config,account,password)
        puts "Hello, #{customer.name(config,account)}!"
        menu(config,account)
      else puts "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH"
        start(config)
      end
    else puts "ERROR: ACCOUNT NUMBER NOT FOUND"
        start(config)
    end
 end

 def balance(config)
  denomination = config['banknotes'].keys
  quantity = config['banknotes'].values
  balance = 0
   (0..8).each do |i|
    balance+= denomination[i]*quantity[i]
    end
  balance
 end

 def menu(config,account)
    puts "Please Choose From the Following Options:
    1. Display Balance
    2. Withdraw
    3. Log Out"
    choise = gets.to_i
  case(choise)
  when(1)
     puts "Your Current Balance is ?#{customer.balance(config,account)}"
     menu(config,account)
  when(2)
     print "Enter Amount You Wish to Withdraw: "
     transaction = Transaction.new
     amount = transaction.get_amount
     transaction.check(config,account,amount)
  when(3)
     puts "#{customer.name(config,account)}, Thank You For Using Our ATM. Good-Bye!"
     start(config)
  else
     puts "ERROR"
     menu(config,account)
  end
 end 
end

class Customer
 def get_account
     print "Please Enter Your Account Number: "
     acc = gets
     account = acc.to_i
 end

 def existing_account?(config,account)
       return true if config['accounts'].has_key?(account)
       false
 end

 def get_password
     print "Please Enter Your Password: "
     pass = gets
     pasword = pass.chomp
 end

 def verified_password?(config,account,password)
     return true if config['accounts'][account]['password'] == password
     false
 end

 def name(config,account)
    name = config['accounts'][account]['name']
 end

 def balance(config,account)
    balance = config['accounts'][account]['balance']
 end
end

class Transaction
 def get_amount
     am = gets
     amount = am.to_i 
 end

 def sufficient_atm_balance?(config,amount)
     return true if atm_balance(config) >= amount
     false
 end

 def sufficient_customer_balance?(config,account,amount)
     return true if customer_balance(config,account) >= amount
     false
 end

 def amount_can_be_composed?(config,amount)
     denomination = config['banknotes'].keys
     quantity = config['banknotes'].values
     unpaid_amount = amount
     (0..8).each do |i|
     temporary_quantity = (unpaid_amount-unpaid_amount%denomination[i])/denomination[i]
     if temporary_quantity <= quantity[i]
      unpaid_amount-= denomination[i]*temporary_quantity
     else
      unpaid_amount-= denomination[i]*quantity[i]
     end  
    end 
   return true if unpaid_amount == 0
          false
 end

 def check(config,account,amount)
     if !sufficient_atm_balance?(config,amount)
         print "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS ?#{atm_balance(config)}. PLEASE ENTER A DIFFERENT AMOUNT:"
         get_amount
         check(config,account,amount)
     else
         if !sufficient_customer_balance?(config,account,amount)
             print "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
             get_amount
             check(config,account,amount)
         else 
             if !amount_can_be_composed?(config,amount)
                 print "ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:"
                 get_amount
                 check(config,account,amount)
             else
                 withdrawal(config,account,amount)
                 puts "Your New Balance is ?#{customer_balance(config,account)}"
                 menu(config,account)
             end
         end
     end
 end

 def withdrawal(config,account,amount)
     denomination = config['banknotes'].keys
     quantity = config['banknotes'].values
     unpaid_amount = amount
     (0..8).each do |i|
     necessary_quantity = (unpaid_amount-unpaid_amount%denomination[i])/denomination[i]
     if necessary_quantity <= quantity[i]
      unpaid_amount-= denomination[i]*necessary_quantity
      quantity[i]-= necessary_quantity
     else
      unpaid_amount-= denomination[i]*quantity[i]
      quantity[i] = 0
     end  
    end 
     (0..8).each do |i|
      config['banknotes'][denomination[i]] = quantity[i]
     end 
      config['accounts'][account]['balance']-= amount
 end
end
 
config = {"banknotes"=>{500=>0, 200=>0, 100=>2, 50=>1, 20=>2, 10=>4, 5=>1, 2=>0, 1=>2}, "accounts"=>{3321=>{"name"=>"Volodymyr", "password"=>"mypass", "balance"=>422}, 5922=>{"name"=>"Iryna", "password"=>"ho#ll_§1", "balance"=>5301}}}

atm=ATM.new

atm.start(config)