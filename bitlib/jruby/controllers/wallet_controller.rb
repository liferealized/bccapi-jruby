require "java"
require "/Users/bdashtba/projects/simple_client/bccapi/bccapi/out/bccapi.jar"
require "/Users/bdashtba/projects/simple_client/bccapi/bitlib/out/bitlib.jar"
include Java

class WalletController

  def self.create_seed_file(username, password, salt)
    seed_manager = com.bccapi.legacy.SeedManager
    #TODO: Sanity check here
    seed_path = SEED_ROOT_PATH+username+".bin"

    seed = seed_manager.generateSeed(password, salt)
    output = java.io.FileOutputStream.new(seed_path)

    seed_manager.savePinProtectedSeed(password, salt, output, seed)
  end
end