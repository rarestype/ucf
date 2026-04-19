import Grammar

extension UCF {
    /// FunctionPattern ::= TuplePattern ( Arrow TypePattern ) ?
    enum FunctionPatternRule: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        typealias Construction = ([TypePattern], TypePattern?)

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> Construction
            where Source.Element == Terminal, Source.Index == Location {
            let tuple: [TypePattern] = try input.parse(as: TuplePatternRule.self)

            if  case ()? = input.parse(as: ArrowRule?.self) {
                return (tuple, try input.parse(as: TypePatternRule.self))
            } else {
                return (tuple, nil)
            }
        }
    }
}
