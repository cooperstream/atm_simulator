# encoding: UTF-8
class Transaction

 attr_accessor :amount

 def initialize(amount= "")
    @amount = amount
 end

 def is_positive_integer?
   /\A\d+\z/.match(@amount)
 end

 def check_amount
   @amount = gets.chomp
   if !is_positive_integer?
     print "ERROR: THE AMOUNT MUST BE POSITIVE AND INTEGER!!PLEASE ENTER A DIFFERENT AMOUNT:"
     check_amount
   else
     @amount = @amount.to_i
   end
 end

end
