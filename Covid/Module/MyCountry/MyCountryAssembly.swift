//
//  MyCountryAssembly.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

final class MyCountryAssembly {
    static func configure(_ dependencies: IDependencies) -> UIViewController {
        return dependencies.moduleContainer.getMyCountryView()
    }
}
