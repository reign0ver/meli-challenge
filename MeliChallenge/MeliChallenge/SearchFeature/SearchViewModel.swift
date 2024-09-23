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
    
    @Published private(set) var state = ViewState.idle
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
        
        state = .loading
        cancellable = httpClient
            .getPublisher(url: url)
            .receive(on: DispatchQueue.main)
            .tryMap(SearchDataMapper.map)
            .sink(
                receiveCompletion: { [weak self] completion in self?.handleCompletion(completion) },
                receiveValue: { [weak self] items in self?.updateUI(items) }
            )
    }
}

private extension SearchViewModel {
    func updateUI(_ items: [SearchItem]) {
        guard !items.isEmpty else { return state = .emptyResults }
        state = .loaded(results: items)
    }
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Publisher finished")
        case .failure(let error):
            print("Error ocurrred!")
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        guard let urlError = error as? URLError else { return print("Couldn't cast to URLError") }
        switch urlError.code {
        case .notConnectedToInternet:
            state = .error(ViewError.notConnectedToInternet.model)
        default:
            state = .error(ViewError.genericError.model)
        }
    }
    
    func subscribeToTextChanges() {
        $searchText
            .sink(
                receiveValue: { [weak self] text in self?.search(text: text) }
            ).store(in: &cancellables)
    }
}

extension SearchViewModel {
    enum ViewState {
        case idle
        case emptyResults
        case loading
        case loaded(results: [SearchItem])
        case error(ViewError.Model)
    }
    
    enum ViewError {
        case notConnectedToInternet
        case genericError
        
        typealias Model = (imageName: String, message: String)
        
        var model: Model {
            switch self {
            case .notConnectedToInternet:
                let message = """
                Parece que no estás conectado a Internet.
                Revisa tu conexión y vuelve a buscar.
                """
                return ("wifi.slash", message)
            case .genericError:
                let message = """
                Parece que algo ocurrió mientras realizabas la búsqueda.
                Vuelve a intentar en unos minutos o valida que la información que intentas buscar sea válida.
                """
                return ("exclamationmark.triangle", message)
            }
        }
    }
}
