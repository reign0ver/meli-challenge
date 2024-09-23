//
//  RemoteDetailItem.swift
//  MeliChallenge
//
//  Created by Andrés Carrillo on 23/09/24.
//

import Foundation

extension DetailDataMapper {
    struct RemoteDetailItem: Decodable {
        let condition: String?
        let pictures: [URL]
        
        private enum CodingKeys: CodingKey {
            case condition
            case pictures
        }
        
        private enum PicturesCodingKeys: String, CodingKey {
            case url = "secure_url"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            condition = try container.decodeIfPresent(String.self, forKey: .condition)
            
            var picturesURL: [URL] = []
            var unkeyedArrayContainer = try container.nestedUnkeyedContainer(forKey: .pictures)
            
            while !unkeyedArrayContainer.isAtEnd {
                let keyedInnerContainer = try unkeyedArrayContainer.nestedContainer(keyedBy: PicturesCodingKeys.self)
                let pictureURL = try keyedInnerContainer.decode(URL.self, forKey: .url)
                picturesURL.append(pictureURL)
            }
            
            pictures = picturesURL
        }
    }
}
