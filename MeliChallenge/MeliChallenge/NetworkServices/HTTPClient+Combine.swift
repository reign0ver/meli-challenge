//
//  HTTPClient+Combine.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Combine
import Foundation

// HTTPClient extension to work with Combine Publishers
// instead of the closure based func defined in the protocol declaration.
public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(url: URL) -> Publisher {
        var task: HTTPClientTask?
        
        return Deferred {
            Future { completion in
                task = self.get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}
