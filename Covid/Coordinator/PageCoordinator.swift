//
//  PageCoordinator.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

protocol PageCoordinatorProtocol: Coordinator {
    func start()
}

final class PageCoordinator: PageCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .page }
    var dependencies: IDependencies
    
    required init(_ navigationController: UINavigationController, dependencies: IDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showPageViewController()
    }
    
    private func showPageViewController() {
        let pageVC = PageAssembly.configure(dependencies)
        let navVC = UINavigationController(rootViewController: pageVC)
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            window.rootViewController = navVC
            UIView.transition(with: window, duration: 1.0, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        } else {
            navVC.modalPresentationStyle = .fullScreen
            navigationController.showDetailViewController(navVC, sender: self)
        }
    }
}
