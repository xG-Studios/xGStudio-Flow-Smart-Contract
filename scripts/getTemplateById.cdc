import XGStudio from 0xc357c8d061353f5f
pub fun main(templateId: UInt64): XGStudio.Template {
    return XGStudio.getTemplateById(templateId: templateId)
}