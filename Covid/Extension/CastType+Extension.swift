//
//  CastType+Extension.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

extension String? {
    var emptyStringIfEmpty: String {
        if let self, self.isNotEmpty { return self }
        return ""
    }
}
extension Int? {
    var zeroIfEmpty: Int {
        if let self { return self }
        return 0
    }
}

extension Data? {
    var emptyDataIfEmpty: Data {
        if let self { return self }
        return Data()
    }
}

extension Collection {
    var isNotEmpty: Bool { isEmpty == false }
    public subscript (safe index: Self.Index) -> Iterator.Element? {
        (startIndex ..< endIndex).contains(index) ? self[index] : nil
    }
    var nilIfEmpty: (any Collection)? { self.isEmpty ? nil : self }
}

struct NonEmpty<T> {
    var head: T
    var tail: [T]
}
extension NonEmpty {
      init(_ head: T, _ tail: [T] = []) {
        self.head = head
        self.tail = tail
      }
//    init(_ head: T, _ tail: T...) {
//      self.head = head
//      self.tail = tail
//    }
    var first: T {
      return head
    }
    var last: T {
      return tail.last ?? head
    }
}
