import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7


pub fun main(address: Address):[UInt64]{
    let account1 = getAccount(address)
    let acct1Capability =  account1.getCapability(xGStudios.CollectionPublicPath)
                           .borrow<&{xGStudios.xGStudiosCollectionPublic}>()
                            ??panic("could not borrow receiver Reference ")
    return  acct1Capability.getIDs()
}