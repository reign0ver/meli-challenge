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
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var items: [SearchItem] = []
    @Published var searchText = ""
    
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
    // Not being called/used for now, read the comments below.
    func onAppear() {
        // Would be a nice to have to perform search starting with 3 characters
        // and then start to debounce the stream to avoid multiple request for every
        // typed character.
        subscribeToTextChanges()
    }
}

extension SearchViewModel {
    func search(text: String) {
        let url = SearchEndpoint.get(search: text).url(baseURL: NetworkURLs.baseURL)
        cancellable = httpClient
            .getPublisher(url: url)
            .receive(on: DispatchQueue.main)
            .tryMap(SearchDataMapper.map)
            .sink(
                receiveCompletion: { print ("completion: \($0)") },
                receiveValue: { [weak self] items in self?.updateUI(items) }
            )
    }
}

private extension SearchViewModel {
    func updateUI(_ items: [SearchItem]) {
        self.items = items
    }
    
    func subscribeToTextChanges() {
        $searchText
            .sink(
                receiveValue: { [weak self] text in self?.search(text: text) }
            ).store(in: &cancellables)
    }
}
