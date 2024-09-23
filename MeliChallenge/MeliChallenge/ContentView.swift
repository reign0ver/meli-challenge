//
//  ContentView.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 21/09/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var searchVM = SearchViewModel()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            SearchView(vm: searchVM, coordinator: coordinator)
                .navigationDestination(
                    for: AppCoordinator.Destination.self,
                    destination: { destination in
                        switch destination {
                        case let .detail(item):
                            let vm = DetailViewModel(item: item)
                            DetailView(vm: vm)
                        }
                    }
                )
        }
    }
}

#Preview {
    ContentView()
}
