//
//  OnboardingViewModel.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import PaperOnboarding

protocol OnboardingViewModelDelegate: AnyObject {
    func getItem(at index: Int) -> OnboardingItemInfo
    var items: [OnboardingItemInfo] { get }
}

final class OnboardingViewModel: OnboardingViewModelDelegate {   
    private lazy var titleFont = UIFont.theme.onboarding.title
    private lazy var descriptionFont = UIFont.theme.onboarding.description
    private let titleColor = UIColor.theme.alwaysWhite
    private let descriptionColor = UIColor.theme.alwaysWhite
    var items: [OnboardingItemInfo] = []
    
    init() {
        configure()
    }
    
    func getItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }

    private func configure() {
        let image1 = UIImage(named: ImageName.onboardingImageFirst)!
        let image2 = UIImage(named: ImageName.onboardingImageSecond)!
        let image3 = UIImage(named: ImageName.onboardingImageThird)!
        items = [
            OnboardingItemInfo(informationImage: image1,
                               title: Constants.onboardingTitleFirst,
                               description: Constants.onboardingDescriptionFirst,
                               pageIcon: UIImage(),
                               color: UIColor.theme.accentIndigo,
                               titleColor: titleColor,
                               descriptionColor: descriptionColor,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: image2,
                               title: Constants.onboardingTitleSecond,
                               description: Constants.onboardingDescriptionSecond,
                               pageIcon: UIImage(),
                               color: UIColor.theme.accentPurple,
                               titleColor: titleColor,
                               descriptionColor: descriptionColor,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: image3,
                               title: Constants.onboardingTitleThird,
                               description: Constants.onboardingDescriptionThird,
                               pageIcon: UIImage(),
                               color: UIColor.theme.accentIndigo,
                               titleColor: titleColor,
                               descriptionColor: descriptionColor,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont)
        ]
    }
}
