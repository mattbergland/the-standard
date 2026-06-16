import Foundation

/// Robustly turns model text into a ``CulturePack``.
///
/// Models sometimes wrap JSON in prose or markdown fences. This parser:
/// 1. tries to decode the whole string,
/// 2. strips ```` ```json ```` fences and retries,
/// 3. extracts the outermost `{ ... }` substring and retries,
/// and throws ``CulturePackError/decoding(_:)`` if none succeed.
public enum CulturePackParser {
    public static func parse(_ raw: String) throws -> CulturePack {
        let candidates = candidateJSONStrings(from: raw)
        let decoder = JSONDecoder()
        for candidate in candidates {
            if let data = candidate.data(using: .utf8),
               let pack = try? decoder.decode(CulturePack.self, from: data) {
                return pack
            }
        }
        throw CulturePackError.decoding("No valid Culture Pack JSON found in the response.")
    }

    /// Ordered list of substrings to attempt decoding, most-specific last.
    static func candidateJSONStrings(from raw: String) -> [String] {
        var candidates: [String] = []
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        candidates.append(trimmed)

        // Strip markdown code fences if present.
        if let fenced = stripCodeFence(trimmed) {
            candidates.append(fenced)
        }

        // Outermost brace span.
        if let start = trimmed.firstIndex(of: "{"),
           let end = trimmed.lastIndex(of: "}"),
           start < end {
            candidates.append(String(trimmed[start...end]))
        }
        return candidates
    }

    private static func stripCodeFence(_ text: String) -> String? {
        guard text.hasPrefix("```") else { return nil }
        var lines = text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        if !lines.isEmpty { lines.removeFirst() }          // ```json
        if lines.last?.trimmingCharacters(in: .whitespaces) == "```" {
            lines.removeLast()
        }
        return lines.joined(separator: "\n")
    }
}
