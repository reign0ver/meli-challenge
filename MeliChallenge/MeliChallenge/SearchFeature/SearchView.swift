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
                Text("Item1")
                Text("Item2")
                Text("Item3")
            }
            .navigationTitle("Busca en Meli")
        }
        .onAppear(perform: { vm.search(text: "magic mouse") })
    }
}

#Preview {
    SearchView()
}
