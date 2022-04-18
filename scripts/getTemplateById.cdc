import xGStudios from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

pub fun main(templateId: UInt64): xGStudios.Template {
    return xGStudios.getTemplateById(templateId: templateId)
}