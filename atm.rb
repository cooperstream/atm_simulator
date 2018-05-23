# encoding: UTF-8
require 'yaml'
require_relative './lib/atm'
require_relative './lib/customer'
require_relative './lib/transaction'
require_relative './lib/withdrawal'

config = YAML.load_file(ARGV.first || 'config.yml')
atm = ATM.new(config['banknotes'])
atm.start(config)
