import Grammar

extension UCF.DisambiguatorRule {
    /// Clauses ::= Space '[' Clause ( ',' Clause ) * ']'
    ///
    /// Note that the leading whitespace is considered part of the filter.
    enum Clauses: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> [(String, String?)]
            where Source.Element == Terminal, Source.Index == Location {
            try input.parse(as: UCF.SpaceRule.self)

            //  No padding around structural characters; ``DisambiguationClauseRule`` already
            //  trims whitespace.
            try input.parse(as: UnicodeEncoding<Location, Terminal>.BracketLeft.self)
            let clauses: [(String, String?)] = try input.parse(
                as: Pattern.Join<Clause, UnicodeEncoding<Location, Terminal>.Comma, [_]>.self
            )
            try input.parse(as: UnicodeEncoding<Location, Terminal>.BracketRight.self)
            return clauses
        }
    }
}
