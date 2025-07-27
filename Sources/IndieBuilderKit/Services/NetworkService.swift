import Foundation

// MARK: - Network Service

/// Simple network service using Swift Concurrency
/// Handles common HTTP operations with proper error handling and JSON support
public final class NetworkService: Sendable {
    
    public static let shared = NetworkService()
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Perform a network request and decode the response
    /// - Parameters:
    ///   - request: The URLRequest to perform
    ///   - responseType: The type to decode the response into
    /// - Returns: Decoded response object
    /// - Throws: NetworkError for various failure cases
    public func request<T: Decodable>(
        _ request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            // Success - decode the response
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
            
        case 400:
            throw NetworkError.badRequest
            
        case 401:
            throw NetworkError.unauthorized
            
        case 403:
            throw NetworkError.forbidden
            
        case 404:
            throw NetworkError.notFound
            
        case 429:
            throw NetworkError.rateLimited
            
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
            
        default:
            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    /// Perform a simple GET request
    /// - Parameters:
    ///   - url: The URL to request
    ///   - headers: Optional additional headers
    ///   - responseType: The type to decode the response into
    /// - Returns: Decoded response object
    public func get<T: Decodable>(
        url: URL,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return try await self.request(request, responseType: responseType)
    }
    
    /// Perform a POST request with JSON body
    /// - Parameters:
    ///   - url: The URL to request
    ///   - body: The object to encode as JSON body
    ///   - headers: Optional additional headers
    ///   - responseType: The type to decode the response into
    /// - Returns: Decoded response object
    public func post<T: Decodable, Body: Encodable>(
        url: URL,
        body: Body,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Encode body
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(body)
        
        return try await self.request(request, responseType: responseType)
    }
    
    /// Perform a PUT request with JSON body
    /// - Parameters:
    ///   - url: The URL to request
    ///   - body: The object to encode as JSON body
    ///   - headers: Optional additional headers
    ///   - responseType: The type to decode the response into
    /// - Returns: Decoded response object
    public func put<T: Decodable, Body: Encodable>(
        url: URL,
        body: Body,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Encode body
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(body)
        
        return try await self.request(request, responseType: responseType)
    }
    
    /// Perform a DELETE request
    /// - Parameters:
    ///   - url: The URL to request
    ///   - headers: Optional additional headers
    ///   - responseType: The type to decode the response into
    /// - Returns: Decoded response object
    public func delete<T: Decodable>(
        url: URL,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Add headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return try await self.request(request, responseType: responseType)
    }
    
    /// Download data without decoding (for images, files, etc.)
    /// - Parameters:
    ///   - url: The URL to download from
    ///   - headers: Optional additional headers
    /// - Returns: Raw data
    public func downloadData(
        url: URL,
        headers: [String: String] = [:]
    ) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
}

// MARK: - Network Errors

public enum NetworkError: LocalizedError, Sendable {
    case invalidResponse
    case decodingFailed(Error)
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case rateLimited
    case serverError(Int)
    case unexpectedStatusCode(Int)
    case noInternetConnection
    case timeout
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response received"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .badRequest:
            return "Bad request (400)"
        case .unauthorized:
            return "Unauthorized (401)"
        case .forbidden:
            return "Forbidden (403)"
        case .notFound:
            return "Not found (404)"
        case .rateLimited:
            return "Rate limited (429)"
        case .serverError(let code):
            return "Server error (\(code))"
        case .unexpectedStatusCode(let code):
            return "Unexpected status code (\(code))"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        }
    }
}

// MARK: - Response Models

/// Generic API response wrapper
public struct APIResponse<T: Codable>: Codable, Sendable {
    public let success: Bool
    public let data: T?
    public let message: String?
    public let error: String?
    
    public init(success: Bool, data: T? = nil, message: String? = nil, error: String? = nil) {
        self.success = success
        self.data = data
        self.message = message
        self.error = error
    }
}

/// Empty response for endpoints that don't return data
public struct EmptyResponse: Codable, Sendable {
    public init() {}
}
