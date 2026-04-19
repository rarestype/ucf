import Grammar

extension UCF.DisambiguatorRule {
    /// Clause ::= AlphanumericWord + ( ':' AlphanumericWord + ) ?
    enum Clause: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> (String, String?)
            where Source.Element == Terminal, Source.Index == Location {
            let label: String = try input.parse(as: AlphanumericWords.self)
            //  No whitespace padding around the colon; ``AlphanumericWords`` already trims.
            if  case ()? = input.parse(as: UnicodeEncoding<Location, Terminal>.Colon?.self) {
                return (label, try input.parse(as: AlphanumericWords.self))
            } else {
                return (label, nil)
            }
        }
    }
}
