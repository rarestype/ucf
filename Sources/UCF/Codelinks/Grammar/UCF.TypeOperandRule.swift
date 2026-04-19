import Grammar

extension UCF {
    /// TypeOperand ::= NominalPattern | BracketPattern | FunctionPattern
    enum TypeOperandRule: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> TypeOperand
            where Source.Element == Terminal, Source.Index == Location {
            if  let path: [(Range<Location>, [TypePattern])] = input.parse(
                    as: NominalPatternRule?.self
                ) {
                if  let (range, generics): (Range<Location>, [TypePattern]) = path.first,
                    generics.isEmpty,
                    path.count == 1,
                    input.source.index(after: range.lowerBound) == range.upperBound,
                    input[range.lowerBound] == "_" {
                    return .single(nil)
                }

                return .nominal(path)
            } else if
                let (first, value): (TypePattern, TypePattern?) = input.parse(
                    as: BracketPatternRule?.self
                ) {
                return .bracket(first, value)
            }

            switch try input.parse(as: FunctionPatternRule.self) {
            case (let tuple, nil):
                if  let first: TypePattern = tuple.first, tuple.count == 1 {
                    return .single(first)
                }

                return .tuple(tuple)

            case (let tuple, let output?):
                return .closure(tuple, output)
            }
        }
    }
}
