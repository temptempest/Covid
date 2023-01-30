//
//  OnboardingViewController.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import PaperOnboarding
import SnapKit

final class OnboardingViewController: UIViewController, PaperOnboardingDataSource {
    enum Event {
        case onboardingComplete
    }
    var didSendEventHandler: ((OnboardingViewController.Event) -> Void)?
    
    var viewModel: OnboardingViewModelDelegate!
    
    private let onboardingView = PaperOnboarding()
    private lazy var imageYOffset: CGFloat = Support.isIphoneSEFirstGeneration ? -128 : -138
    
    private lazy var appearAnimator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
    }()
    
    private lazy var dismissAnimator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.1, curve: .linear)
    }()
    
    private lazy var temporaryImageView: UIImageView = {
        let image = UIImage(named: ImageName.onboardingImageFirst)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.continueText, for: .normal)
        button.titleLabel?.font = UIFont.theme.onboarding.buttonTitle
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(UIColor.theme.alwaysWhite, for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.skipText, for: .normal)
        button.titleLabel?.font = UIFont.theme.onboarding.buttonTitle
        button.setTitleColor(UIColor.theme.alwaysWhite, for: .normal)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appearAnimator.startAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addAnimations()
    }
    
    private func addAnimations() {
        skipButton.isUserInteractionEnabled = false
        nextButton.isUserInteractionEnabled = false
        onboardingView.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.theme.accentIndigo
        nextButton.alpha = 0
        skipButton.alpha = 0
        onboardingView.alpha = 0
        view.addSubview(temporaryImageView)
        
        temporaryImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(240)
        }
        temporaryImageView.transform = .init(scaleX: 0.78, y: 0.78).translatedBy(x: 0, y: imageYOffset)
        
        appearAnimator.addAnimations {
            self.nextButton.alpha = 1
            self.skipButton.alpha = 1
            self.onboardingView.alpha = 1
            self.onboardingView.transform = .init(scaleX: 1, y: 1)
        }
        appearAnimator.addCompletion { position in
            switch position {
            case .end: self.dismissAnimator.startAnimation()
            case .start, .current: break
            @unknown default: break
            }
        }
        dismissAnimator.addAnimations({
            self.temporaryImageView.alpha = 0
        })
        dismissAnimator.addCompletion { _ in
            self.skipButton.isUserInteractionEnabled = true
            self.nextButton.isUserInteractionEnabled = true
            self.onboardingView.isUserInteractionEnabled = true
            self.temporaryImageView.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        onboardingView.dataSource = self
        onboardingView.dataSource = self
        view.addSubview(onboardingView)
        
        onboardingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func nextButtonTapped() {
        let nextIndex = onboardingView.currentIndex + 1
        onboardingView.currentIndex(nextIndex, animated: true)
        
        if nextIndex >= viewModel.items.count {
            dismiss()
        }
    }
    
    @objc private func skipButtonTapped() {
        dismiss()
    }
    func dismiss() {
        didSendEventHandler?(.onboardingComplete)
    }
}

extension OnboardingViewController {
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return viewModel.getItem(at: index)
    }
    func onboardingItemsCount() -> Int {
        return viewModel.items.count
    }
}

// MARK: Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct OnboardingViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let dependency = DependenciesMock()
        let viewController = OnboardingAssembly.configure(dependency)
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
