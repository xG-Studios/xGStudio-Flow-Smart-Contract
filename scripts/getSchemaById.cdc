import XGStudio from "../contracts/XGStudio.cdc"


pub fun main(schemaId: UInt64): XGStudio.Schema {
    return XGStudio.getSchemaById(schemaId: schemaId)
}