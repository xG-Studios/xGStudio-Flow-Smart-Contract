import XGStudio from 0xd9575c84a88eada0
pub fun main(templateId: UInt64): XGStudio.Template {
    return XGStudio.getTemplateById(templateId: templateId)
}