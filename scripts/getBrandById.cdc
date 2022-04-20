import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae


pub fun main(brandId:UInt64): AnyStruct{
    return xGStudios.getBrandById(brandId: brandId)
}