import xGStudios from 0x91d21b0c6bbecfae
import NonFungibleToken from 0x91d21b0c6bbecfae

pub fun main(schemaId: UInt64): xGStudios.Schema {
    return xGStudios.getSchemaById(schemaId: schemaId)
}