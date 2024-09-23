//
//  DetailViewModel.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import Combine
import Foundation

enum ViewState {
    case loading
    case loaded(searchItem: SearchItem, detailItem: DetailItem)
    case error
}

final class DetailViewModel: ObservableObject {
    private let item: SearchItem
    private let httpClient: HTTPClient
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state = ViewState.loading
    
    init(
        item: SearchItem,
        httpClient: HTTPClient = URLSessionHTTPClient()
    ) {
        self.item = item
        self.httpClient = httpClient
    }
    
    deinit {
        print("Deinit DetailViewModel")
    }
}

extension DetailViewModel {
    func onAppear() {
        fetchPictures()
    }
}

private extension DetailViewModel {
    func fetchPictures() {
        let url = DetailEndpoint.get(itemId: item.id).url(baseURL: NetworkURLs.baseURL)
        httpClient.getPublisher(url: url)
            .receive(on: DispatchQueue.main)
            .tryMap(DetailDataMapper.map)
            .sink(
                receiveCompletion: { print ("completion: \($0)") },
                receiveValue: { [weak self] items in self?.updateUI(items) }
            ).store(in: &cancellables)
    }
    
    func updateUI(_ itemDetail: DetailItem) {
        state = .loaded(searchItem: item, detailItem: itemDetail)
    }
}
