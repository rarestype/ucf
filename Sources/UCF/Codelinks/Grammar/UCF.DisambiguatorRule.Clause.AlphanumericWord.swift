import Grammar

extension UCF.DisambiguatorRule.Clause {
    /// AlphanumericWord ::= Space ? [0-9A-Za-z] + Space ?
    enum AlphanumericWord: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> Range<Location>
            where Source.Element == Terminal, Source.Index == Location {
            input.parse(as: UCF.SpaceRule?.self)

            let start: Location = input.index
            try input.parse(as: AlphanumericCodepoint.self)
            input.parse(as: AlphanumericCodepoint.self, in: Void.self)
            let end: Location = input.index

            input.parse(as: UCF.SpaceRule?.self)

            return start ..< end
        }
    }
}
