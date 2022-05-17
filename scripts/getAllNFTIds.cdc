import XGStudio from 0xc357c8d061353f5f


pub fun main(address: Address):[UInt64]{
    let account1 = getAccount(address)
    let acct1Capability =  account1.getCapability(XGStudio.CollectionPublicPath)
                            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
                            ??panic("could not borrow receiver Reference ")
    return  acct1Capability.getIDs()
}