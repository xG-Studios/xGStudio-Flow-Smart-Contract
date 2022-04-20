import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae

pub fun main(templateId: UInt64): xGStudios.Template {
    return xGStudios.getTemplateById(templateId: templateId)
}