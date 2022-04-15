import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

pub fun main(brandId:UInt64): String {
    let Completebrand= xGStudios.getBrandById(brandId: brandId)

    return Completebrand.brandName
}