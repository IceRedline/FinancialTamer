//
//  NetworkClient.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 14.07.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int, String?)
}

final class NetworkClient {
    
    private let session: URLSession
    private let token: String = Constants.bearerToken
    
    init() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: config)
    }
    
    func request<Response: Decodable>(
        url: URL,
        method: String = Constants.get,
        body: (any Encodable)? = nil, /// на тип тела запроса наложено ограничение соответсвия протоколу Encodable
        headers: [String: String] = [:],
        responseType: Response.Type
    ) async throws -> Response {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Headers
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Body (POST / PUT)
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw NetworkError.serverError(httpResponse.statusCode, message)
        }
        
        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
