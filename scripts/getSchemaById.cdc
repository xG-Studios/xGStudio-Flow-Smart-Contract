import XGStudio from 0xd9575c84a88eada0


pub fun main(schemaId: UInt64): XGStudio.Schema {
    return XGStudio.getSchemaById(schemaId: schemaId)
}