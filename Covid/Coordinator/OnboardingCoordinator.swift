//
//  OnboardingCoordinator.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

protocol OnboardingCoordinatorProtocol: Coordinator {
    func start()
}

final class OnboardingCoordinator: OnboardingCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .onboarding }
    var dependencies: IDependencies
    required init(_ navigationController: UINavigationController, dependencies: IDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showOnboardingViewController()
    }
    
    func showOnboardingViewController() {
        let onboardingViewController = OnboardingAssembly.configure(dependencies)
        if let onboardingViewController = onboardingViewController as? OnboardingViewController {
            onboardingViewController.didSendEventHandler = { [weak self] event in
                switch event {
                case .onboardingComplete:
                    self?.finish()
                }
            }
        }
        navigationController.pushViewController(onboardingViewController, animated: false)
    }
}
