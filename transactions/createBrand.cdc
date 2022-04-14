import XGStudio from 0xff321cc072da62b3

transaction (){
    prepare(acct: AuthAccount) {
        let actorResource = acct.getCapability
            <&{XGStudio.NFTMethodsCapability}>
            (XGStudio.NFTMethodsCapabilityPrivatePath)
            .borrow() ?? 
            panic("could not borrow a reference to the NFTMethodsCapability interface")
        let data  : {String:String} = {
            "name":"XGStudio",
            "description":"xG® rewards athletes’ real world sports participation with personalised digital collectibles and the xG® utility token.",
            "url":"https://xgstudios.io"   
        }
        
        actorResource.createNewBrand(
        brandName: "XGStudio",
        data: data)
    
    }
}