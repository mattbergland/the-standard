import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Default Anthropic Messages API endpoint.
public let anthropicMessagesURL = URL(string: "https://api.anthropic.com/v1/messages")!

/// A current Claude model. Override via ``ClaudeProvider``'s initializer if a
/// newer model becomes available.
public let defaultClaudeModel = "claude-sonnet-4-6"

/// Builds the `URLRequest` for the Anthropic Messages API.
///
/// Factored out from ``ClaudeProvider`` so headers and JSON body can be unit
/// tested on Linux without performing any network I/O.
public enum AnthropicRequestBuilder {
    /// Shape of the JSON body POSTed to the Messages API.
    struct Body: Encodable {
        struct Message: Encodable {
            let role: String
            let content: String
        }
        let model: String
        let max_tokens: Int
        let system: String
        let messages: [Message]
    }

    public static func makeRequest(
        for problem: TeamProblem,
        apiKey: String,
        model: String = defaultClaudeModel,
        maxTokens: Int = 1200,
        url: URL = anthropicMessagesURL
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body = Body(
            model: model,
            max_tokens: maxTokens,
            system: PromptBuilder.systemPrompt(),
            messages: [.init(role: "user", content: PromptBuilder.userPrompt(for: problem))]
        )
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
}

/// Minimal decoding of the Anthropic Messages API response.
struct AnthropicResponse: Decodable {
    struct ContentBlock: Decodable {
        let type: String
        let text: String?
    }
    let content: [ContentBlock]

    /// Concatenated text from all `text` content blocks.
    var joinedText: String {
        content.compactMap { $0.type == "text" ? $0.text : nil }.joined()
    }
}
