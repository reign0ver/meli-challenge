//
//  AppCoordinator.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var navigationPath: [Destination] = []
    
    func start() {
        navigationPath = []
    }
    
    func navigate(to destination: Destination) {
        navigationPath.append(destination)
    }
}

extension AppCoordinator {
    enum Destination: Hashable {
        case detail(item: SearchItem)
    }
}
