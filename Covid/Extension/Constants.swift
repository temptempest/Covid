//
//  Constants.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

enum API {
    static let baseUrl = "https://api.covid19api.com/"
    static let flagUrl = "https://countryflagsapi.com/png/"
}

enum Constants {
    static let onboardingTitleFirst = "Welcome"
    static let onboardingTitleSecond = "COVID 19 Statistic"
    static let onboardingTitleThird = "Tracking COVID 19"
    static let onboardingDescriptionFirst = "The app contains current information on coronavirus infection."
    static let onboardingDescriptionSecond = "You can see statistics on coronavirus around the world and in your country."
    static let onboardingDescriptionThird = "You can track:\nTotal confirmed cases, active cases, recovered cases, fatal cases."
    static let all = "All"
    static let myCountry = "My Country"
    static let allCountries = "All Countries"
    static let skipText = "SKIP"
    static let continueText = "CONTINUE"
    static let checkInternet = "Check your internet connection"
    static let totalConfirmed = "Total Confirmed"
    static let totalActive = "Total Active"
    static let newConfirmed = "Today Confirmed"
    static let totalRecovered = "Total Recovered"
    static let newRecovered = "Today Recovered"
    static let totalDeath = "Total Death"
    static let newDeath = "Today Death"
    static let topTotalDeath = "TOP Total Death"
    static let searchByCountryAndCode = "Search by Country and Code"
    static let countryNotFound = "Country Not Found"
    static let notSetCountry = "County not set -->"
    static let okString = "OK"
    static let setCountry = "Set Your Country"
    static let loadingText = "Loading..."
}

enum ImageName {
    static let onboardingImageFirst = "onboardingFirst"
    static let onboardingImageSecond = "onboardingSecond"
    static let onboardingImageThird = "onboardingThird"
}

enum SystemImageName {
    static let sliderVertical = "slider.vertical.3"
    static let sliderHorizontal = "slider.horizontal.3"
}

enum UserDefaultsKey {
    static let onboardingComplete = "OnboardingComplete"
    static let myCountry = "MyCountry"
}

enum CoreDataConstant {
    static let summaryContainerName = "SummaryContainer"
    static let summaryEntityName = "SummaryEntity"
    static let worldContainerName: String = "WorldContainer"
    static let worldEntityName: String = "WorldEntity"
    static let detailCountryContainerName: String = "DetailCountryContainer"
    static let detailCountryEntityName: String = "DetailCountryEntity"
}
