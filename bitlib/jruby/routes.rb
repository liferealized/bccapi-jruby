require "rubygems"
require "bundler/setup"
require "java"
require "sinatra"

require "controllers/wallet_controller"
include Java

require "/Users/bdashtba/projects/simple_client/bccapi/bccapi/out/bccapi.jar"
require "/Users/bdashtba/projects/simple_client/bccapi/bitlib/out/bitlib.jar"

SEED_ROOT_PATH = "/Users/bdashtba/projects/simple_client/seeds/"



get '/account/:username/:password' do
  WalletController.load_account(@params[:username], @params[:password])
end

get '/register' do
  erb :register
end

post '/register' do
  @username = @params[:username]
  @password = @params[:password]
  @email    = @params[:email]
  @salt     = @params[:salt]
  wallet = WalletController.create_seed_file(@username, @password, @salt)
  erb :successful_register
end

get '/balance/:username/:password' do
    balance_str = WalletController.load_balance(@params[:username], @params[:password])
end

#TODO: Sanity check
def sanitize(word)
  word
end
