//
//  SwiftLog.swift
//  SwiftLog
//
//  Created by Alexandre Oliveira on 28/08/2024.
//

import Foundation

public class SwiftLog {
    
    private static let service = Service()
    
    /// Saves a string to the server via the provided API.
    /// - Parameters:
    ///   - string: The string to be saved.
    ///   - completion: Completion handler called with the result of the operation.
    public static func saveString(_ string: String, completion: @escaping (Result<Void, Error>) -> Void) {
        service.sendString(string, completion: completion)
    }
}
