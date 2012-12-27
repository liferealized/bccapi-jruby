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
    puts "Hello JRuby World!"
     key_ring   = com.bccapi.bitlib.crypto.PrivateKeyRing.new()


    seed_file = java.io.FileInputStream.new(SEED_ROOT_PATH+@params[:username]+".bin")
    #TODO: remove password from URL
    seed = com.bccapi.legacy.SeedManager.loadPinProtectedSeed(@params[:password], seed_file);

     keyManager = com.bccapi.legacy.DeterministicECKeyManager.new(seed)
     network    = com.bccapi.bitlib.model.NetworkParameters.productionNetwork

     key_ring.addPrivateKey(keyManager.getPrivateKey(1), network)
     output = ""
     addresses =  key_ring.getAddresses
     addresses.each do |address|
        output+= "Your Address key: "+address.toString
     end
     output
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

#TODO: Sanity check
def sanitize(word)
  word
end
