//
//  APIRequest.swift
//  DataFetch
//
//  Created by Bhavitha Gottimukkula on 08/08/24.
//

import Foundation


struct Parameters: Encodable {
    let param1: String
    let param2: String
}

struct APIRequest: NetworkRequestProtocol {
    
    var url: URL? {
        return URL(string: APIConfig.baseURL)
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [HTTPHeader : String]? {
        return [.contentType: ContentType.json.rawValue]
    }
    
    var parameters: Encodable? {
        return Parameters(param1: "Hi", param2: "Hello")
    }

}

struct APIConfig {
    static let baseURL = "https://api.github.com/users/Bhavitha"
}
