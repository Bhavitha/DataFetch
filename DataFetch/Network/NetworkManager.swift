//
//  NetworkManager.swift
//  DataFetch
//
//  Created by Bhavitha Gottimukkula on 07/08/24.
//

import Foundation

//MARK: Create NetwrokManager singletom


//protocol URLSessionProtocol {
//    func data(for request: URLRequest) async throws -> (Data, URLResponse)
//}
//
//extension URLSession: URLSessionProtocol {}
//
//private let session: URLSessionProtocol
//    private let decoder: JSONDecoderProtocol
//    
//    init(session: URLSessionProtocol = URLSession.shared, decoder: JSONDecoderProtocol = JSONDecoder()) {
//        self.session = session
//        self.decoder = decoder
//    }
    
protocol URLSessionProtocol {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSessionProtocol
    private init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func perform<T: Decodable>(request: NetworkRequestProtocol,  retries: Int = 3, decodeTo: T.Type) async throws -> T {
        // T: Decodable indicates that this function is a generic function it can work with any type which conforms to Decodable protocol
        var attempts = 0
        while attempts <= retries {
            do {
                let urlRequest = try request.urlRequest()
                if #available(iOS 15.0, *) {
                    let (data, response) = try await session.data(for: urlRequest)
                    try handleResponse(response: response)
                    return try decodeData(data: data)
                } else {
                    //Write code for older versions
                }
            } catch let error as NSError {
                attempts += 1
                if attempts > retries || error.code != NSURLErrorNetworkConnectionLost {
                    throw error
                }
                print("Attempt \(attempts) failed, retrying...")
            }
            
        }
        throw URLError(.cannotConnectToHost)
    }
    
    private func handleResponse(response: URLResponse?) throws {
        guard let httpResonse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch httpResonse.statusCode {
        case 200...209: return
        case 404: throw NetworkError.notFound
        case 500: throw NetworkError.internalServerError
        default: throw NetworkError.unknownError(statusCode: httpResonse.statusCode)
        }
    }
    
    private func decodeData<T: Decodable>(data: Data) throws -> T {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch let error {
            throw NetworkError.decodingFailed(error)
        }
    }
    
}
