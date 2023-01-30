//
//  PageViewController.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

final class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    enum Event {
        case page
    }
    var didSendEventHandler: ((PageViewController.Event) -> Void)?
    var controllers: [UIViewController] = []
    var startIndex = 0
    private lazy var currentIndex = startIndex {
        didSet {
            segmentControl.selectedSegmentIndex = currentIndex
        }
    }
    private lazy var items = controllers.map { $0.title }
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: items as [Any])
        segmentControl.addTarget(self, action: #selector(handleIndexChanged), for: .valueChanged)
        return segmentControl
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupUI()
        configure(controllers: controllers)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.theme.background
        segmentControl.selectedSegmentIndex = startIndex
        navigationItem.titleView = segmentControl
    }
    
    private func configure(controllers: [UIViewController]) {
        self.controllers = controllers
        dataSource = self
        delegate = self
        guard let controller = controllers[safe: 0] else { return }
        setViewControllers([controller], direction: .forward, animated: false)
    }
}

extension PageViewController {
    @objc
    private func handleIndexChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection =
        selectedIndex < currentIndex ? .reverse : .forward
        setViewControllers([controllers[selectedIndex]], direction: direction, animated: true)
        currentIndex = selectedIndex
    }
}

// MARK: - UIPageViewControllerDataSource
extension PageViewController {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}).zeroIfEmpty
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}).zeroIfEmpty
        if index == 0 { return nil }
        return controllers[index - 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension PageViewController {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
      guard completed,
        let currentVC = pageViewController.viewControllers?.first,
        let index = controllers.firstIndex(of: currentVC) else { return }
        currentIndex = index
    }
}

// MARK: Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct PageViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let dependency = DependenciesMock()
        let viewController = UINavigationController(rootViewController: PageAssembly.configure(dependency))
        Group {
            PreviewViewController(viewController)
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Light")
            PreviewViewController(viewController)
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
