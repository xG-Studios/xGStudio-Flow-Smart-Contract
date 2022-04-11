import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction(recipient: Address) {

//the NFTMInter will sign this transaction
  prepare(acct: AuthAccount) {

    let nftMinter = acct.borrow<&xGStudios.NFTMinter>(from:/storage/Minter)! 
   
    let publicReference = getAccount(recipient).getCapability(/public/collection)
                        .borrow<&xGStudios.Collection{NonFungibleToken.CollectionPublic}>()
                        ??panic("This account doesn't have a collection")

    publicReference.deposit(token: <- nftMinter.createNFT())

  }

  execute {
    log("Stored newly minted NFT into Collection")
  }
}
