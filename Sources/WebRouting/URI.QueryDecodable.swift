import URI

extension URI {
    public protocol QueryDecodable<QueryKey> {
        associatedtype QueryKey: RawRepresentable<String>, Hashable
        init(from uri: borrowing QueryDecoder<QueryKey>) throws
    }
}
extension URI.QueryDecodable {
    @inlinable public init(decoding uri: borrowing URI.Query) throws {
        let decoder: URI.QueryDecoder<QueryKey> = .init(indexing: uri.parameters)
        try self.init(from: decoder)
    }
}
