require "rubygems"
require "bundler/setup"
require "java"
require "sinatra"
include Java

require "/Users/bdashtba/projects/simple_client/bccapi/bccapi/out/bccapi.jar"
require "/Users/bdashtba/projects/simple_client/bccapi/bitlib/out/bitlib.jar"

get '/account' do
    puts "Hello JRuby World!"
     key_ring   = com.bccapi.bitlib.crypto.PrivateKeyRing.new()

     seedFile = java.io.FileInputStream.new("/Users/bdashtba/projects/simple_client/bccapi/bccapi/seed.bin")
     seed = com.bccapi.legacy.SeedManager.loadPinProtectedSeed("9493", seedFile );

     keyManager = com.bccapi.legacy.DeterministicECKeyManager.new(seed)
     network    = com.bccapi.bitlib.model.NetworkParameters.productionNetwork

     key_ring.addPrivateKey(keyManager.getPrivateKey(1), network)
     output = ""
     addresses =  key_ring.getAddresses
     addresses.each do |address|
        output+= "Your Address: "+address.toString
     end
     output
end
