//
//  Service.swift
//  SwiftLog
//
//  Created by Alexandre Oliveira on 28/08/2024.
//

import Foundation

final class Service {

    private let urlString: String
    private let session: URLSession
    
    public init(urlString: String = "https://us-central1-mobilesdklogging.cloudfunctions.net/saveString", session: URLSession = .shared) {
        self.urlString = urlString
        self.session = session
    }
    
    public func sendString(_ myString: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["myString": myString]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(ServiceError.invalidRequestBody))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
    
    public enum ServiceError: Error {
        case invalidURL
        case invalidRequestBody
        case invalidResponse
    }
}
