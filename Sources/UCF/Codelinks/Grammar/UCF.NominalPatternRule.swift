import Grammar

extension UCF {
    /// NominalPattern ::= PathComponent ( '.' PathComponent ) *
    enum NominalPatternRule: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar
        typealias Construction = [(Range<Location>, [UCF.TypePattern])]

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> Construction
            where Source.Element == Terminal, Source.Index == Location {
            try input.parse(
                as: Pattern.Join<
                    PathComponent,
                    UnicodeEncoding<Location, Terminal>.Period,
                    Construction
                >.self
            )
        }
    }
}
