//
//  HTTPURLResponse+StatusCode.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
