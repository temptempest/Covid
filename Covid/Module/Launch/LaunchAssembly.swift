//
//  LaunchAssembly.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

final class LaunchAssembly {
    static func configure(_ dependencies: IDependencies) -> UIViewController {
        return dependencies.moduleContainer.getLaunchView()
    }
}
