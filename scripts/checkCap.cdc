import XGStudio from "../contracts/XGStudio.cdc"

pub fun main(account:Address):Bool{
    let account = getAccount(account)
    let cap = account.getCapability(XGStudio.CollectionPublicPath)
            .borrow<&{XGStudio.XGStudioCollectionPublic}>()
    if cap == nil {
        return false
    }
    return true
}