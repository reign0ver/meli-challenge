//
//  SearchView.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 22/09/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                switch vm.state {
                case .idle: 
                    getInitialStateView()
                case .loading: 
                    ProgressView()
                case .loaded(let results):
                    getSearchResultsView(results)
                case .emptyResults:
                    getEmptyView()
                case .error(let errorModel):
                    getErrorView(errorModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .navigationTitle("Busca en Meli")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(
            text: $vm.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Buscar")
        )
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .scrollDismissesKeyboard(.interactively)
        .onSubmit(of: .search) { vm.search(text: vm.searchText) }
    }
    
    private func getSearchResultsView(_ items: [SearchItem]) -> some View {
        List {
            ForEach(items) { item in
                // Fix this
                // It is initializing and later releasing the Views/ViewModels
                // of the visible Rows in the List
                NavigationLink(
                    destination: { DetailView(vm: .init(item: item)) },
                    label: { SearchItemRow(item: item) }
                )
                .listRowInsets(EdgeInsets())
                .buttonStyle(.plain)
            }
        }
        .listStyle(.plain)
        .listRowSpacing(12)
    }
    
    private func getInitialStateView() -> some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "text.magnifyingglass")
                .imageScale(.large)
            
            Text("¿Qué esperas para empezar a buscar?😎")
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private func getEmptyView() -> some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .imageScale(.large)
            
            Text("Parece que no pudimos encontrar lo que buscabas😢")
                .font(.body)
                .multilineTextAlignment(.center)
            
            Text("¡Pero no te preocupes que estamos mejorando para traerte todo lo que necesitas!")
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private func getErrorView(_ model: SearchViewModel.ViewError.Model) -> some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: model.imageName)
                .imageScale(.large)
            
            Text(model.message)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
