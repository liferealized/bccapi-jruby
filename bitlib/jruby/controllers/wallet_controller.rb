require "java"
require "/Users/bdashtba/projects/simple_client/bccapi/bccapi/out/bccapi.jar"
require "/Users/bdashtba/projects/simple_client/bccapi/bitlib/out/bitlib.jar"
include Java

class WalletController

  def self.get_network
    com.bccapi.bitlib.model.NetworkParameters.productionNetwork
  end

  def self.get_key_ring(username, pin)
    key_ring = com.bccapi.bitlib.crypto.PrivateKeyRing.new()
    seed_file = java.io.FileInputStream.new(SEED_ROOT_PATH+username+".bin")
    #TODO: remove password from URL
    seed = com.bccapi.legacy.SeedManager.loadPinProtectedSeed(pin, seed_file);
    seed_file.close

    keyManager = com.bccapi.legacy.DeterministicECKeyManager.new(seed)
    network = get_network()

    key_ring.addPrivateKey(keyManager.getPrivateKey(1), network)
    key_ring
  end


  def self.create_seed_file(username, password, salt)
    seed_manager = com.bccapi.legacy.SeedManager
    #TODO: Sanity check here
    seed_path = SEED_ROOT_PATH+username+".bin"

    seed = seed_manager.generateSeed(password, salt)
    output = java.io.FileOutputStream.new(seed_path)

    seed_manager.savePinProtectedSeed(password, salt, output, seed)
  end

  def self.load_account(username, pin)
    key_ring = get_key_ring(username, pin)
    output = ""
    addresses = key_ring.getAddresses
    addresses.each do |address|
      output+= "Your Address key: "+address.toString
    end
    output+= " <a href='/balance/#{username}/#{pin}'>Balance</a>"
  end


  def self.load_balance(username, pin)
    key_ring = get_key_ring(username, pin)
    request =  com.bccapi.ng.api.QueryBalanceRequest.new(key_ring.getAddresses())
    url = java.net.URL.new("http://bqs1.bccapi.com:80")
    api = com.bccapi.ng.impl.BitcoinClientApiImpl.new(url, get_network);
    result = api.queryBalance(request);

    available = result.balance.unspent + result.balance.pendingChange;
    coin_util = com.bccapi.bitlib.util.CoinUtil
    return ("Available:"+
      coin_util.valueString(available)  +
      " BTC  Sending:" +
      coin_util.valueString(result.balance.pendingSending) +
      " BTC  Receiving:" +
      coin_util.valueString(result.balance.pendingReceiving) +
      " BTC")
  end



end