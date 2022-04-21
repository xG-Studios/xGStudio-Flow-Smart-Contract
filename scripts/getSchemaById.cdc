import XGStudio from 0xff321cc072da62b3


pub fun main(schemaId: UInt64): XGStudio.Schema {
    return XGStudio.getSchemaById(schemaId: schemaId)
}