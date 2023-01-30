//
//  LaunchViewController.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import SnapKit

final class LaunchViewController: UIViewController {
    enum Event {
        case launchComplete
    }
    var didSendEventHandler: ((LaunchViewController.Event) -> Void)?
    var isShowOnboardingBefore: Bool = false
    
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
    }()
    
    private lazy var imageYOffset: CGFloat = Support.isIphoneSEFirstGeneration ? -128 : -138
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: ImageName.onboardingImageFirst)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if isShowOnboardingBefore {
            showLaunchToMainFlowAnimation()
        } else {
            showLaunchToOnboardingAnimation()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.theme.accentIndigo
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(240)
        }
    }
    
    private func showLaunchToOnboardingAnimation() {
        animator.addAnimations {
            self.imageView.transform = .init(scaleX: 0.78, y: 0.78).translatedBy(x: 0, y: self.imageYOffset)
        }
        animator.addCompletion { position in
            switch position {
            case .end: self.didSendEventHandler?(.launchComplete)
            case .start, .current: break
            @unknown default: break
            }
        }
        animator.startAnimation(afterDelay: 2.0)
    }
    
    private func showLaunchToMainFlowAnimation() {
        animator.addAnimations {
            self.imageView.transform = .init(scaleX: 2, y: 2)
            self.imageView.alpha = 0
        }
        animator.addCompletion { position in
            switch position {
            case .end: self.didSendEventHandler?(.launchComplete)
            case .start, .current: break
            @unknown default: break
            }
        }
        animator.startAnimation(afterDelay: 1.0)
    }
}

// MARK: Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct LaunchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let dependency = DependenciesMock()
        let viewController = LaunchAssembly.configure(dependency)
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
