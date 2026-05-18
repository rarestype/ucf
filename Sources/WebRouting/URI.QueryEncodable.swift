import URI

extension URI {
    public protocol QueryEncodable<QueryKey> {
        associatedtype QueryKey: RawRepresentable<String>
        func encode(to uri: inout QueryEncoder<QueryKey>)
    }
}
extension URI.QueryEncodable {
    @inlinable public func append(to uri: inout URI.Query) {
        var encoder: URI.QueryEncoder<QueryKey> = .init(query: consume uri)
        self.encode(to: &encoder)
        uri = encoder.query
    }

    @inlinable public var encoded: URI.Query {
        var uri: URI.Query = .init()
        self.append(to: &uri)
        return uri
    }
}
