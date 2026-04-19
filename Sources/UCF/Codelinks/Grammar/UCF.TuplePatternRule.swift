import Grammar

extension UCF {
    /// TuplePattern ::= '(' \s * ( TypePattern ( \s * ',' TypePattern ) * ) ? \s * ')'
    enum TuplePatternRule: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> [TypePattern]
            where Source.Element == Terminal, Source.Index == Location {
            try input.parse(as: UnicodeEncoding<Location, Terminal>.ParenthesisLeft.self)
            input.parse(as: UnicodeEncoding<Location, Terminal>.Space.self, in: Void.self)

            /// This is not a Join, as it is legal for there to be no elements in the tuple.
            var types: [TypePattern] = []

            if  let type: TypePattern = input.parse(as: TypePatternRule?.self) {
                types.append(type)

                while case ()? = input.parse(
                        as: Pattern.Pad<
                            UnicodeEncoding<Location, Terminal>.Comma,
                            UnicodeEncoding<Location, Terminal>.Space
                        >?.self
                    ) {
                    types.append(try input.parse(as: TypePatternRule.self))
                }
            }

            input.parse(as: UnicodeEncoding<Location, Terminal>.Space.self, in: Void.self)
            try input.parse(as: UnicodeEncoding<Location, Terminal>.ParenthesisRight.self)

            return types
        }
    }
}
