import XGStudio from "../contracts/XGStudio.cdc"
    transaction(){
        prepare(acct:AuthAccount){
            let storage <- acct.load<@XGStudio.Collection>(from: XGStudio.CollectionStoragePath)
                        ??panic("could not load")
            destroy storage
    }
}