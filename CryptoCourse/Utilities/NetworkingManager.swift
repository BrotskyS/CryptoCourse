//
//  NetworkingManager.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 08.06.2022.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url): return "[🔥]Bad response from URL: \(url)"
            case .unknown: return "[⚠️]Unknown error"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
           .subscribe(on: DispatchQueue.global(qos: .default))
           .tryMap({ try  handleURLResponse(output: $0, url: url)})
           .receive(on: DispatchQueue.main)
           .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws  -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300
        else{
            throw NetworkingError.badUrlResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleComlition(comlition: Subscribers.Completion<Error>){
        switch comlition{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
