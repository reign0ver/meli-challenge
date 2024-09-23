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
            List {
                ForEach(vm.items) { item in
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
}

#Preview {
    SearchView()
}
