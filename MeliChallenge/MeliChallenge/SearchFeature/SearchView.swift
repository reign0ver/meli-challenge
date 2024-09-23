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
            List(
                vm.items,
                rowContent: { item in
                    SearchItemRow(item: item)
                }
            )
            .listStyle(.plain)
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
