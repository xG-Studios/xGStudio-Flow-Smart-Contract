import XGStudio from "../contracts/XGStudio.cdc"

pub fun main(): {UInt64:XGStudio.Schema} {
    return XGStudio.getAllSchemas()
}