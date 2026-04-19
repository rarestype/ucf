import Grammar

extension UCF {
    /// Identifier ::= ( ``FirstCodepoint`` ``NextCodepoint`` * ) - 'Type' | '`' '`' ^ '`'
    enum IdentifierRule: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> Range<Location>
            where Source.Element == Terminal, Source.Index == Location {
            let start: Location = input.index

            if  case ()? = input.parse(as: FirstCodepoint?.self) {
                input.parse(as: NextCodepoint.self, in: Void.self)
            } else {
                try input.parse(as: UnicodeEncoding<Location, Terminal>.Backtick.self)
                input.parse(as: RawCodepoint.self, in: Void.self)
                try input.parse(as: UnicodeEncoding<Location, Terminal>.Backtick.self)
            }

            let end: Location = input.index

            if  input[start ..< end].elementsEqual(["T", "y", "p", "e"]) {
                throw .arbitrary(IdentifierError.reserved)
            } else {
                return start ..< end
            }
        }
    }
}
