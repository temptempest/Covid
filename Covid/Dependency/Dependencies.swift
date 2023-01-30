//
//  Dependencies.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

protocol IDependencies {
    var moduleContainer: IModuleContainer { get }
    var userDefaultsRepository: IUserDefaultsRepository { get }
    var networkService: IHTTPClient { get }
    var countriesCountriesService: ICountriesService { get }
    var myCountryService: ICountryService { get }
    var summaryService: ISummaryService { get }
    var worldService: IWorldService { get }
    var flagImageService: IFlagImageService { get }
    var alertBuilder: IAlertsBuilder { get }
    var summaryCoreDataService: ISummaryCoreDataService { get }
    var worldCoreDataService: IWorldCoreDataService { get }
    var detailCountryCoreDataService: ICountryCoreDataService { get }
    var analyticsReporterService: IAnalyticsReporterService { get }
}

final class Dependencies: IDependencies {
    lazy var moduleContainer: IModuleContainer = ModuleContainer(self)
    lazy var userDefaultsRepository: IUserDefaultsRepository = UserDefaultsRepository(container: UserDefaults.standard)
    lazy var networkService: IHTTPClient = HTTPClient()
    lazy var countriesCountriesService: ICountriesService = CountriesService(self)
    lazy var myCountryService: ICountryService = CountryService(self)
    lazy var summaryService: ISummaryService = SummaryService(self)
    lazy var worldService: IWorldService = WorldService(self)
    lazy var flagImageService: IFlagImageService = FlagImageService()
    lazy var alertBuilder: IAlertsBuilder = AlertsBuilder()
    lazy var summaryCoreDataService: ISummaryCoreDataService = SummaryCoreDataService()
    lazy var worldCoreDataService: IWorldCoreDataService = WorldCoreDataService()
    lazy var detailCountryCoreDataService: ICountryCoreDataService = CountryCoreDataService()
    lazy var analyticsReporterService: IAnalyticsReporterService = AnalyticsReporterService()
}

// MARK: - Mock
final class DependenciesMock: IDependencies {
    lazy var moduleContainer: IModuleContainer = ModuleContainer(self)
    lazy var userDefaultsRepository: IUserDefaultsRepository = UserDefaultsRepository(container: UserDefaults.standard)
    lazy var networkService: IHTTPClient = HTTPClient()
    lazy var countriesCountriesService: ICountriesService = CountriesServiceMock()
    lazy var myCountryService: ICountryService = CountryServiceMock()
    lazy var summaryService: ISummaryService = SummaryServiceMock()
    lazy var worldService: IWorldService = WorldServiceMock()
    lazy var flagImageService: IFlagImageService = FlagImageService()
    lazy var alertBuilder: IAlertsBuilder = AlertsBuilder()
    lazy var summaryCoreDataService: ISummaryCoreDataService = SummaryCoreDataService()
    lazy var worldCoreDataService: IWorldCoreDataService = WorldCoreDataService()
    lazy var detailCountryCoreDataService: ICountryCoreDataService = CountryCoreDataService()
    lazy var analyticsReporterService: IAnalyticsReporterService = AnalyticsReporterService()
}
