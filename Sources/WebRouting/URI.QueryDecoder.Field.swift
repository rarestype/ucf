import URI

extension URI.QueryDecoder {
    @frozen public struct Field<Value> {
        @usableFromInline let id: QueryKey
        @usableFromInline let value: Value

        @inlinable init(id: QueryKey, value: Value) {
            self.id = id
            self.value = value
        }
    }
}
extension URI.QueryDecoder.Field<String> {
    @inlinable public func decode<T>(
        to _: T.Type = T.self
    ) throws -> T where T: LosslessStringConvertible {
        guard let value: T = .init(self.value) else {
            throw URI.QueryParameterDecodingError<T>.invalid(
                self.id.rawValue,
                value: self.value
            )
        }

        return value
    }
}
extension URI.QueryDecoder.Field<String?> {
    @inlinable public func decode<T>(
        to _: T.Type = T.self
    ) throws -> T where T: LosslessStringConvertible {
        guard
        let string: String = self.value else {
            throw URI.QueryParameterDecodingError<T>.missing(self.id.rawValue)
        }

        let field: URI.QueryDecoder.Field<String> = .init(id: self.id, value: string)
        return try field.decode()
    }
}
