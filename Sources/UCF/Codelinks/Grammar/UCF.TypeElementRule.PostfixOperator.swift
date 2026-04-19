import Grammar

extension UCF.TypeElementRule {
    /// PostfixOperator ::= '?' | '!' | '.Type' | '...'
    enum PostfixOperator: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> UCF.TypeOperator
            where Source.Element == Terminal, Source.Index == Location {
            if  let codepoint: UCF.TypeOperator = input.parse(
                    as: PostfixOperatorCodepoint?.self
                ) {
                return codepoint
            }

            try input.parse(as: UnicodeEncoding<Location, Terminal>.Period.self)

            if  case ()? = input.parse(as: PostfixMetatype?.self) {
                return .metatype
            } else {
                try input.parse(as: UnicodeEncoding<Location, Terminal>.Period.self)
                try input.parse(as: UnicodeEncoding<Location, Terminal>.Period.self)
                return .ellipsis
            }
        }
    }
}
