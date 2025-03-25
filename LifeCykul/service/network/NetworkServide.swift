//
//  NetworkServide.swift
//  LifeCykul
//
//  Created by Rishop Babu on 25/03/25.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = URLConstants.baseURLString
    
    private init() {}
    
    // Perform a GET request
    func get<T: Decodable>(endpoint: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Perfoem a POST request
    func post<T: Decodable>(endpoint: String, body: [String: String]) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else {
            print("❌ Invalid URL: \(endpoint)")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create form-data body
        let bodyData = createMultipartBody(parameters: body, boundary: boundary)
        request.httpBody = bodyData
        
        print("📡 Hitting API: \(request.url?.absoluteString ?? "No URL")")
        print("📤 Request Body: \(String(data: bodyData, encoding: .utf8) ?? "Binary Data")")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { output in
                print("✅ Raw API Response: \(String(data: output.data, encoding: .utf8) ?? "Invalid Data")")
            })
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createMultipartBody(parameters: [String: String], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            let fieldString = "--\(boundary)\r\n"
            + "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            + "\(value)\r\n"
            if let fieldData = fieldString.data(using: .utf8) {
                body.append(fieldData)
            }
        }
        
        // Add closing boundary
        let closingBoundary = "--\(boundary)--\r\n"
        if let closingData = closingBoundary.data(using: .utf8) {
            body.append(closingData)
        }
        
        return body
    }
}

enum HTTPMethod: String {
    case get
    case post
}
