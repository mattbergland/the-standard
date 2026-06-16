import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Live ``AIProvider`` backed by the Anthropic Messages API.
///
/// The API key is read from the `ANTHROPIC_API_KEY` environment variable by
/// default (or the host's runtime configuration) and is never hardcoded.
public struct ClaudeProvider: AIProvider {
    private let apiKey: String?
    private let model: String
    private let session: URLSession
    private let url: URL

    /// - Parameters:
    ///   - apiKey: Defaults to the `ANTHROPIC_API_KEY` environment variable.
    ///   - model: A current Claude model name.
    ///   - session: Injectable for testing; defaults to `.shared`.
    ///   - url: Endpoint override; defaults to the public Messages API.
    public init(
        apiKey: String? = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"],
        model: String = defaultClaudeModel,
        session: URLSession = .shared,
        url: URL = anthropicMessagesURL
    ) {
        self.apiKey = apiKey?.isEmpty == true ? nil : apiKey
        self.model = model
        self.session = session
        self.url = url
    }

    public func generateCulturePack(for problem: TeamProblem) async throws -> CulturePack {
        guard let apiKey else { throw CulturePackError.missingAPIKey }

        let request = try AnthropicRequestBuilder.makeRequest(
            for: problem,
            apiKey: apiKey,
            model: model,
            url: url
        )

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw CulturePackError.transport(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw CulturePackError.http(status: http.statusCode, body: body)
        }

        let decoded: AnthropicResponse
        do {
            decoded = try JSONDecoder().decode(AnthropicResponse.self, from: data)
        } catch {
            throw CulturePackError.decoding("Unexpected response envelope: \(error.localizedDescription)")
        }

        return try CulturePackParser.parse(decoded.joinedText)
    }
}
