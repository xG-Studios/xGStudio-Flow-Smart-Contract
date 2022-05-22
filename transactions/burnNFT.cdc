import XGStudio from 0xc357c8d061353f5f
import NonFungibleToken from 0x1d7e57aa55817448

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