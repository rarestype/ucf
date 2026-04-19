import Grammar

extension UCF.NominalPatternRule {
    /// PathComponent ::= Identifier GenericArguments ?
    enum PathComponent: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        typealias Construction = (Range<Location>, [UCF.TypePattern])

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> Construction
            where Source.Element == Terminal, Source.Index == Location {
            let base: Range<Location> = try input.parse(as: UCF.IdentifierRule.self)
            return (base, input.parse(as: GenericArguments?.self) ?? [])
        }
    }
}
