import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

pub fun main(account:Address): [UInt64] {
  let publicReference = getAccount(account).getCapability(/public/collection)
                        .borrow<&xGStudios.Collection{NonFungibleToken.CollectionPublic}>()
                        ??panic("This account doesn't have a collection")
  return publicReference.getIDs()
}
