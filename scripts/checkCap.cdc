import XGStudio from 0xd9575c84a88eada0

pub fun main(account:Address):Bool{
    let account = getAccount(account)
    let cap = account.getCapability(XGStudio.CollectionPublicPath)
            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
    if cap == nil {
        return false
    }
    return true
}