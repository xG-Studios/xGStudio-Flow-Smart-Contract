import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

//the person we're giving an NFT to:
transaction(recipient: Address, id:UInt64) {

//the giver of an NFT
  prepare(acct: AuthAccount) {

    let collection = acct.borrow<&xGStudios.Collection>(from:/storage/Collection)! 
   
    let publicReference = getAccount(recipient).getCapability(/public/collection)
                        .borrow<&xGStudios.Collection{NonFungibleToken.CollectionPublic}>()
                        ??panic("This account doesn't have a collection")

    publicReference.deposit(token: <- collection.withdraw(withdrawID:id))

  }

  execute {
    log("Transfered an NFT into Collection")
  }
}
