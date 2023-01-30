//
//  Country.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation
// Response -> [Country]
struct Country: Codable, Hashable {
    let country: String
    let slug: String
    let iso2: String
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case slug = "Slug"
        case iso2 = "ISO2"
    }
    var flag: Data?
}
