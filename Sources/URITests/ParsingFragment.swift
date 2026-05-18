import Testing
import URI

@Suite struct ParsingFragment {
    @Test static func Word() throws {
        let fragment: URI.Fragment = try #require(.init(decoding: "Parameters"))
        #expect(fragment.decoded == "Parameters")
    }

    @Test static func WithSpaces() throws {
        let fragment: URI.Fragment = try #require(.init(decoding: "Getting%20started"))
        #expect(fragment.decoded == "Getting started")
    }
}
