import URI

extension URI {
    @frozen public struct QueryEncoder<QueryKey>: ~Copyable
        where QueryKey: RawRepresentable<String> {
        @usableFromInline var query: URI.Query
        @inlinable init(query: consuming URI.Query) {
            self.query = query
        }
    }
}
extension URI.QueryEncoder {
    @inlinable public subscript<Value>(
        key: QueryKey
    ) -> Value? where Value: CustomStringConvertible {
        get {
            nil
        }
        set(value) {
            if  let value: Value {
                self.query.parameters.append((key.rawValue, "\(value)"))
            }
        }
    }
}
