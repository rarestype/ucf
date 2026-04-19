import Grammar

extension UCF {
    /// Space ::= \s + | '-'
    enum SpaceRule: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError)
            where Source.Element == Terminal, Source.Index == Location {
            if  case ()? = input.parse(as: UnicodeEncoding<Location, Terminal>.Space?.self) {
                input.parse(as: UnicodeEncoding<Location, Terminal>.Space.self, in: Void.self)
            } else {
                try input.parse(as: UnicodeEncoding<Location, Terminal>.Hyphen.self)
            }
        }
    }
}
