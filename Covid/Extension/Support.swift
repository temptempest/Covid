//
//  CheckDevice.swift
//  Covid
//
//  Created by temptempest on 19.12.2022.
//
import UIKit

enum Support {
    static let isIphoneSEFirstGeneration: Bool = {
        return UIDevice.current.userInterfaceIdiom == .phone &&
        max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568
    }()
}
