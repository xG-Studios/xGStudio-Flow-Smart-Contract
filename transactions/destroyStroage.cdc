import XGStudio from 0xff321cc072da62b3
    transaction(){
        prepare(acct:AuthAccount){
            let storage <- acct.load<@XGStudio.Collection>(from: XGStudio.CollectionStoragePath)
                        ??panic("could not load")
            destroy storage
    }
}