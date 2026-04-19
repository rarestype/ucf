import Grammar

extension UCF.DisambiguatorRule.Clause {
    enum AlphanumericWords: ParsingRule {
        typealias Location = String.Index
        typealias Terminal = Unicode.Scalar

        static func parse<Source>(
            _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
        ) throws(PatternMatchingError) -> String
            where Source.Element == Terminal, Source.Index == Location {
            let first: Range<Location> = try input.parse(as: AlphanumericWord.self)
            var words: String = input.source[first].reduce(into: "") {
                $0.append(Character.init($1))
            }

            while let next: Range<Location> = input.parse(as: AlphanumericWord?.self) {
                words.append(" ")

                for scalar: Terminal in input.source[next] {
                    words.append(Character.init(scalar))
                }
            }
            return words
        }
    }
}
