//
//  Colors.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

extension UIColor {
    static let theme = ColorTheme()
}
extension UIFont {
    static let theme = FontTheme()
}

struct ColorTheme {
    let accentIndigo = UIColor(named: "AccentColor")!
    let accentPurple = UIColor(named: "AccentPurple")!
    let background = UIColor(named: "Background")!
    let text = UIColor(named: "TextColor")!
    let secondaryText = UIColor(named: "SecondaryTextColor")!
    let red = UIColor(named: "Red")!
    let redLighter = UIColor(named: "Red")!.lighter(by: 20)!
    let blue = UIColor(named: "Blue")!
    let blueLighter = UIColor(named: "Blue")!.lighter(by: 15)!
    let green = UIColor(named: "Green")!
    let greenLighter = UIColor(named: "Green")!.lighter(by: 10)!
    let orange = UIColor(named: "Orange")!
    let yellow = UIColor(named: "Yellow")!
    let alwaysWhite = UIColor(named: "AccentWhite")!
}

struct FontTheme {
    let onboarding = OnboardingFont()
    let statistic = StatisticViewFont()
    let myCountry = MyCountryVCFont()
    let searchCountry = SearchCountryVCFont()
    let allCountry = AllCountryVCFont()
}
extension FontTheme {
    struct OnboardingFont {
        static let titleFontSize: CGFloat = Support.isIphoneSEFirstGeneration ? 35 : 40
        static let descriptionFontSize: CGFloat = Support.isIphoneSEFirstGeneration ? 18 : 22
        let title = UIFont.systemFont(ofSize: titleFontSize, weight: .heavy)
        let description = UIFont.systemFont(ofSize: descriptionFontSize, weight: .semibold)
        let buttonTitle = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    struct StatisticViewFont {
        static let fontSize: CGFloat = Support.isIphoneSEFirstGeneration ? 15 : 18
        let title = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
        let counter = UIFont.systemFont(ofSize: fontSize, weight: .black)
    }

    struct AllCountryVCFont {
        let section = UIFont.systemFont(ofSize: 20, weight: .heavy)
    }

    struct MyCountryVCFont {
        let countryLabel = UIFont.systemFont(ofSize: 30, weight: .heavy)
    }
    struct SearchCountryVCFont {
        let topLabel = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let notFoundLabel = UIFont.systemFont(ofSize: 25, weight: .semibold)
    }
}
