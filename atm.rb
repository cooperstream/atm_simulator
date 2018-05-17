# encoding: UTF-8

def start
   # config = YAML.load_file(ARGV.first || 'config.yml')
   config = {"banknotes"=>{500=>0, 200=>0, 100=>2, 50=>1, 20=>2, 10=>4, 5=>1, 2=>0, 1=>2}, "accounts"=>{3321=>{"name"=>"Volodymyr", "password"=>"mypass", "balance"=>422}, 5922=>{"name"=>"Iryna", "password"=>"ho#ll_1", "balance"=>5301}}}
    atm = ATM.new("")
    customer = Customer.new("","","","")
    transaction = Transaction.new
    atm.banknotes = atm.get_banknotes(config)
    customer.account = customer.get_account
    if customer.existing_account?(config,customer.account)
       customer.password = customer.get_password
      if customer.verified_password?(config,customer.account,customer.password)
          customer.name = customer.get_name(config,customer.account)
          customer.balance = customer.get_balance(config,customer.account)
        puts "Hello, #{customer.name}!"
        atm.menu(customer,transaction)
      else puts "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH"
        start
      end
    else puts "ERROR: ACCOUNT NUMBER NOT FOUND"
        start
    end
 end


class ATM
    
 attr_accessor :banknotes

 def initialize(banknotes)
  @banknotes = banknotes
 end
 
 def get_banknotes(config)
     banknotes = config['banknotes']
 end
 
 def balance
  denomination = banknotes.keys
  quantity = banknotes.values
  balance = 0
    (0..8).each do |i|
     balance+= denomination[i]*quantity[i]
    end
  balance
 end

 def menu(customer,transaction)
    puts "Please Choose From the Following Options:
    1. Display Balance
    2. Withdraw
    3. Log Out"
    choise = gets.to_i
    case(choise)
    when(1)
     puts "Your Current Balance is $#{customer.balance}"
     menu(customer,transaction)
    when(2)
     print "Enter Amount You Wish to Withdraw: "
     transaction.check(self,customer)
    when(3)
     puts "#{customer.name}, Thank You For Using Our ATM. Good-Bye!"
     start
    else
     puts "ERROR"
     menu(customer,transaction)
    end
 end
   
end



class Customer
    
 attr_accessor :account, :password, :name, :balance
 
 def initialize(account,password,name,balance)
  @accont = account
  @password = password
  @name = name
  @balance = balance
 end
 
 def get_account
     print "Please Enter Your Account Number: "
     acc = gets
     account = acc.to_i
 end
 
 def existing_account?(config,account)
      config['accounts'].has_key?(account)
 end
 
 def get_password
     print "Please Enter Your Password: "
     pass = gets
     pasword = pass.chomp
 end
 
 def verified_password?(config,account,password)
     config['accounts'][account]['password'] == password
 end
 
 def get_name(config,account)
     name = config['accounts'][account]['name']
 end
 
 def get_balance(config,account)
     balance = config['accounts'][account]['balance']
 end
 
end
 
class Transaction
    
 
 
 def get_amount
     am = gets
     amount = am.to_i 
 end

 def sufficient_atm_balance?(amount,atm)
     atm.balance >= amount
 end

 def sufficient_customer_balance?(amount,customer)
     customer.balance >= amount
 end

 def can_be_composed?(amount,atm)
     denomination = atm.banknotes.keys
     quantity = atm.banknotes.values
     unpaid_amount = amount
     (0..8).each do |i|
     issued_banknotes = (unpaid_amount-unpaid_amount%denomination[i])/denomination[i]
     if issued_banknotes <= quantity[i]
      unpaid_amount-= denomination[i]*issued_banknotes
     else
      unpaid_amount-= denomination[i]*quantity[i]
     end  
    end 
     unpaid_amount == 0
 end

 def check(atm,customer)
     amount = get_amount
     if !sufficient_atm_balance?(amount,atm)
         print "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS $#{atm.balance}. PLEASE ENTER A DIFFERENT AMOUNT:"
         check(atm,customer)
     else
         if !sufficient_customer_balance?(amount,customer)
             print "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
             check(atm,customer)
         else 
             if !can_be_composed?(amount,atm)
                 print "ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:"
                 check(atm,customer)
             else
                 withdrawal(amount,atm,customer)
                 puts "Your New Balance is $#{customer.balance}"
                 atm.menu(customer,self)
             end
         end
     end
 end

 def withdrawal(amount,atm,customer)
     denomination = atm.banknotes.keys
     quantity = atm.banknotes.values
     unpaid_amount = amount
     (0..8).each do |i|
     issued_banknotes = (unpaid_amount-unpaid_amount%denomination[i])/denomination[i]
     if issued_banknotes <= quantity[i]
      unpaid_amount-= denomination[i]*issued_banknotes
      quantity[i]-= issued_banknotes
     else
      unpaid_amount-= denomination[i]*quantity[i]
      quantity[i] = 0
     end  
    end 
     
      (0..8).each do |i|
      atm.banknotes[denomination[i]] = quantity[i]
      end
      customer.balance-= amount
	  
	  # update config.yml
end 


start