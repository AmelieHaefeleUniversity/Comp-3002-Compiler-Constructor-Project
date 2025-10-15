import Foundation

let input: String = try String(
    contentsOf: URL(fileURLWithPath: "Sources/Grammars/toyParserGrammarWithMacros.txt"),
    encoding: .utf8)

let input_first_follow: String = try String(
    contentsOf: URL(fileURLWithPath: "Sources/Grammars/toyParserGrammarToTestFollowSets.txt"),
    encoding: .utf8)

let input_scanner: String = try String(contentsOf: URL(fileURLWithPath: "Sources/Grammars/toyScannerGrammar.txt"), encoding: .utf8)


print(Constructor.example1(grammar_text: input))

Constructor.example1(grammar_text: input_scanner)

Constructor.exampleWithFirstFollow(grammar_text: input_first_follow)

