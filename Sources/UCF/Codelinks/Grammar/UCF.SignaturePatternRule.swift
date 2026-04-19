import Grammar

extension UCF {
    /// SignaturePattern ::= FunctionPattern | Arrow TypePattern
    enum SignaturePatternRule: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> SignaturePattern
            where Source.Element == Terminal, Source.Index == Location {
            if  case ()? = input.parse(as: ArrowRule?.self) {
                input.parse(as: UnicodeEncoding<Location, Terminal>.Space.self, in: Void.self)
                return .returns(try input.parse(as: TypePatternRule.self))
            } else {
                let function: (inputs: [TypePattern], output: TypePattern?) = try input.parse(
                    as: FunctionPatternRule.self
                )
                return .function(function.inputs, function.output)
            }
        }
    }
}
