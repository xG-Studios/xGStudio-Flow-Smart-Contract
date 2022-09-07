import XGStudio from "../contracts/XGStudio.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"

// This transaction will burn the NFT from user-address

// Parameters:
// nftId: The id of the NFT to be burned

transaction(nftID:UInt64) {
    // local variable for storing the transferred token
    let nftToken: @NonFungibleToken.NFT
    prepare(acct: AuthAccount) {
        let collectionRef =  acct.borrow<&XGStudio.Collection>(from: XGStudio.CollectionStoragePath)
        ??panic("could not borrow a reference to the the stored nft Collection")
        self.nftToken <- collectionRef.withdraw(withdrawID: nftID)
    }

    execute {
                destroy self.nftToken
    }
}