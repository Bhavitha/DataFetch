//
//  File.swift
//  DataFetch
//
//  Created by Bhavitha Gottimukkula on 09/08/24.
//

import Foundation

//MARK: STEP1 Create Netwrok Error enum

enum NetworkError: Error {
    case invalidURL
    case internalServerError
    case badRequest
    case invalidResponse
    case decodingFailed(Error)
    case notFound
    case unknownError(statusCode: Int)
    case encodingFailed(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "POST"
}

enum HTTPHeader: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
}
