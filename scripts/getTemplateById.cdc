import XGStudio from 0xff321cc072da62b3
pub fun main(templateId: UInt64): XGStudio.Template {
    return XGStudio.getTemplateById(templateId: templateId)
}