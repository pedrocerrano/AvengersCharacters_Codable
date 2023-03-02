//
//  ComicList.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/2/23.
//

import Foundation

struct ComicTopLevelDictionary: Decodable {
    private enum CodingKeys: String, CodingKey {
        case comicListData = "data"
    }
    
    let comicListData: ComicsResults
}

struct ComicsResults: Decodable {
    private enum CodingKeys: String, CodingKey {
        case offset
        case comicResults = "results"
    }
    
    let offset: Int
    let comicResults: [Comic]
}

struct Comic: Decodable {
    private enum CodingKeys: String, CodingKey {
        case comicTitle = "title"
        case comicImage = "thumbnail"
    }
    
    let comicTitle: String
    let comicImage: ComicThumbnail
}

struct ComicThumbnail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case imagePath      = "path"
        case imageExtention = "extension"
    }
    
    let imagePath: String
    let imageExtention: String
}


