import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction {

  prepare(acct: AuthAccount) {
    acct.save(<- xGStudios.createEmptyCollection(), to: /storage/Collection)
    acct.link<&xGStudios.Collection{NonFungibleToken.CollectionPublic,xGStudios.MyCollectionPublic}>(/public/collection, target:/storage/Collection)
  }

  execute {
    log("Stored a Collection for our xGStudios")
  }
}
