import Foundation

// MARK: - Models

struct FuzzySearchMatchResult {
    let weight: Int
    let matchedParts: [NSRange]
}

struct FuzzySearchCharacter {
    let content: String
    let normalisedContent: String
}

struct FuzzySearchString {
    var characters: [FuzzySearchCharacter]
}
