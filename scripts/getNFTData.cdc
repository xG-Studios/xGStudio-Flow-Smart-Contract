import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

pub fun main(account:Address, id:UInt64): String {
  let publicReference = getAccount(account).getCapability(/public/collection)
                        .borrow<&xGStudios.Collection{xGStudios.MyCollectionPublic}>()
                        ??panic("This account doesn't have a collection")
  return publicReference.borrowEntireNFT(id:id).name
}
