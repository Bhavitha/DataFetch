//
//  NetworkRequestProtocol.swift
//  DataFetch
//
//  Created by Bhavitha Gottimukkula on 09/08/24.
//

import Foundation

protocol NetworkRequestProtocol {
    var url: URL? { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader: String]? {get}
    var parameters: Encodable? { get }
}

extension NetworkRequestProtocol {
    func urlRequest() throws -> URLRequest {
        guard let url = url else { throw NetworkError.invalidURL }
        var urlRequest = URLRequest(url: url)
        // Set HTTP method
        urlRequest.httpMethod = method.rawValue
        //Set Headers
        if let headers = headers {
            for(key, val) in headers {
                urlRequest.setValue(val, forHTTPHeaderField: key.rawValue)
            }
        }
        //Set Params
        
        if let parameters = parameters {
                   if method == .get {
                       var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                       let parameterData = try JSONEncoder().encode(parameters)
                       let parameterDictionary = try JSONSerialization.jsonObject(with: parameterData, options: []) as? [String: Any]
                       urlComponents?.queryItems = parameterDictionary?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                       urlRequest.url = urlComponents?.url
                   } else {
                       do {
                           let jsonData = try JSONEncoder().encode(parameters)
                           urlRequest.httpBody = jsonData
                       } catch {
                           throw NetworkError.encodingFailed(error)
                       }
                   }
               }
        
        return urlRequest
    }
}
