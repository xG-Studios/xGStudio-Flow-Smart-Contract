import XGStudio from 0xc357c8d061353f5f


pub fun main(schemaId: UInt64): XGStudio.Schema {
    return XGStudio.getSchemaById(schemaId: schemaId)
}