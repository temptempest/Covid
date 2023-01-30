//
//  LoadJson.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

public func loadJson<T: Decodable>(bundle: Bundle, fileName: String, type: T.Type) -> T {
    guard let path = bundle.path(forResource: fileName, ofType: "json") else { fatalError("Loading Error") }
    do {
        let data: Data = try .init(contentsOf: URL(fileURLWithPath: path))
        let object = try JSONDecoder().decode(type, from: data)
        return object
    } catch {
        fatalError("Decoding Error")
    }
}
