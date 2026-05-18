import URI

extension URI {
    @frozen public struct QueryDecoder<QueryKey>: ~Copyable
        where QueryKey: Hashable & RawRepresentable<String> {
        @usableFromInline let values: [QueryKey: String]
        @inlinable init(values: [QueryKey: String]) {
            self.values = values
        }
    }
}
extension URI.QueryDecoder {
    @inlinable init(indexing parameters: [URI.Query.Parameter]) {
        self.init(
            values: parameters.reduce(into: .init(minimumCapacity: parameters.count)) {
                if let key: QueryKey = .init(rawValue: $1.key) {
                    $0[key] = $1.value
                }
            }
        )
    }
}
extension URI.QueryDecoder {
    @inlinable public subscript(_ key: QueryKey) -> Field<String?> {
        return .init(id: key, value: self.values[key])
    }

    @inlinable public subscript(_ key: QueryKey) -> Field<String>? {
        if  let value: String = self.values[key] {
            return .init(id: key, value: value)
        } else {
            return nil
        }
    }
}
