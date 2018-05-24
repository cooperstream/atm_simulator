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

end
