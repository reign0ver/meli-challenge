//
//  SearchViewModel.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {
    private let httpClient: HTTPClient
    private var cancellable: Cancellable?
    
    init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }
    
    deinit {
        cancellable?.cancel()
        cancellable = nil
        print("Deinit SearchViewModel")
    }
}

extension SearchViewModel {
    func search(text: String) {
        let url = SearchEndpoint.get(search: text).url(baseURL: NetworkURLs.baseURL)
        
        cancellable = httpClient
            .getPublisher(url: url)
        // Not sure if the subscription happens in the main thread :thinking_face:
        // Test the next line and debug the thread is which the completion is executed
//            .receive(on: DispatchQueue.main)
            .tryMap(SearchDataMapper.map)
            .sink(
                receiveCompletion: { print ("completion: \($0)") },
                receiveValue: { print ("value: \($0)") }
            )
    }
}
