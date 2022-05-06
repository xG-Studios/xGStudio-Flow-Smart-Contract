import XGStudio from 0xd9575c84a88eada0
pub fun main(brandId:UInt64): AnyStruct{
    return XGStudio.getBrandById(brandId: brandId)
}