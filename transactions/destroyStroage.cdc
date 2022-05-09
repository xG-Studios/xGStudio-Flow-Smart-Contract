import XGStudio from 0xc357c8d061353f5f
    transaction(){
        prepare(acct:AuthAccount){
            let storage <- acct.load<@XGStudio.Collection>(from: XGStudio.CollectionStoragePath)
                        ??panic("could not load")
            destroy storage
    }
}