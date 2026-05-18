import URI

extension URI {
    @frozen @usableFromInline enum QueryParameterDecodingError<T>: Error {
        case missing(String)
        case invalid(String, value: String)
    }
}
extension URI.QueryParameterDecodingError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .missing(let key):
            """
            missing value for query parameter '\(key)'
            """

        case .invalid(let key, value: let value):
            """
            failed to decode value '\(value)' for query parameter '\(key)' \
            to expected type '\(String.init(reflecting: T.self))'
            """
        }
    }
}
