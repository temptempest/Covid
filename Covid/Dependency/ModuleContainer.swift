//
//  ModuleContainer.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

protocol IModuleContainer {
    func getLaunchView() -> UIViewController
    func getOnboardingView() -> UIViewController
    func getPageView() -> UIViewController
    func getAllCountryView() -> UIViewController
    func getMyCountryView() -> UIViewController
    func getSearchCountryView() -> UIViewController
}

final class ModuleContainer: IModuleContainer {
    private let dependencies: IDependencies
    required init(_ dependencies: IDependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - PageVC
extension ModuleContainer {
    func getPageView() -> UIViewController {
        let view = PageViewController()
        let allCountryVC = AllCountryAssembly.configure(dependencies)
        let myCountryVC = MyCountryAssembly.configure(dependencies)
        let searchCountryVC = SearchCountryAssembly.configure(dependencies)
        view.controllers = [allCountryVC, myCountryVC, searchCountryVC]
        view.startIndex = 0
        return view
    }
}
// MARK: - AllCountryVC
extension ModuleContainer {
    func getAllCountryView() -> UIViewController {
        let view = AllCountryViewController()
        view.title = Constants.all
        let viewModel = AllCountryViewModel(dependencies)
        view.viewModel = viewModel
        return view
    }
}
// MARK: - MyCountryVC
extension ModuleContainer {
    func getMyCountryView() -> UIViewController {
        let view = MyCountryViewController()
        view.title = Constants.myCountry
        let viewModel = MyCountryViewModel(dependencies)
        view.viewModel = viewModel
        return view
    }
}
// MARK: - SearchCountryVC
extension ModuleContainer {
    func getSearchCountryView() -> UIViewController {
        let view = SearchCountryViewController()
        view.title = Constants.allCountries
        let viewModel = SearchCountryViewModel(dependencies)
        view.viewModel = viewModel
        return view
    }
}
// MARK: - LaunchVC
extension ModuleContainer {
    func getLaunchView() -> UIViewController {
        return LaunchViewController()
    }
}
// MARK: - OnboardingVC
extension ModuleContainer {
    func getOnboardingView() -> UIViewController {
        let view = OnboardingViewController()
        let viewModel = OnboardingViewModel()
        view.viewModel = viewModel
        return view
    }
}
