import XGStudio from 0xff321cc072da62b3

pub fun main(account:Address):Bool{
    let account = getAccount(account)
    let cap = account.getCapability(XGStudio.CollectionPublicPath)
            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
    if cap == nil {
        return false
    }
    return true
}