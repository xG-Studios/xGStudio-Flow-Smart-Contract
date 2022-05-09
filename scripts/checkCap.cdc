import XGStudio from 0xc357c8d061353f5f

pub fun main(account:Address):Bool{
    let account = getAccount(account)
    let cap = account.getCapability(XGStudio.CollectionPublicPath)
            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
    if cap == nil {
        return false
    }
    return true
}