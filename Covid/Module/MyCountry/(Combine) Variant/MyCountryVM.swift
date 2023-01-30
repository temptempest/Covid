////
////  MyCVM.swift
////  Covid
////
////  Created by temptempest on 19.12.2022.
////
// swiftlint:disable comment_spacing
//import Foundation
//import Combine
//
//enum MyCountryDataType {
//    case confirmed
//    case recovered
//    case active
//    case death
//}
//
//protocol MyCountryViewModelDelegate: AnyObject {
//    typealias Model = [DetailCountry]
//    var country: Model { get }
//    var published: Published<Model> { get }
//    var publisher: Published<Model>.Publisher { get }
//
//    var countryName: String { get }
//    var countryNamePublished: Published<String> { get }
//    var countryNamePublisher: Published<String>.Publisher { get }
//
//    typealias ChartAndTotalValueType = ([Chart], Int, MyCountryDataType)
//    var chartAndTotalValue: ChartAndTotalValueType { get }
//    var chartAndTotalValuePublished: Published<ChartAndTotalValueType> { get }
//    var chartAndTotalValuePublisher: Published<ChartAndTotalValueType>.Publisher { get }
//
//    func getCountry()
//    func getChartAndTotalValue(_ type: MyCountryDataType)
//}
//
//final class MyCountryViewModel: MyCountryViewModelDelegate {
//    @Published var country: Model = []
//    var published: Published<Model> { _country }
//    var publisher: Published<Model>.Publisher { $country }
//
//    @Published var countryName: String = ""
//    var countryNamePublished: Published<String> { _countryName }
//    var countryNamePublisher: Published<String>.Publisher { $countryName }
//
//    @Published var chartAndTotalValue: ChartAndTotalValueType = ([], 0, .confirmed)
//    var chartAndTotalValuePublished: Published<ChartAndTotalValueType> { _chartAndTotalValue }
//    var chartAndTotalValuePublisher: Published<ChartAndTotalValueType>.Publisher { $chartAndTotalValue }
//
//    private var dataService: ICountryService?
//    private var userDefaultsManager: IUserDefaultsManager?
//
//    init(_ dependencies: IDependencies) {
//        self.dataService = dependencies.myCountryService
//        self.userDefaultsManager = dependencies.userDefaultsManager
//    }
//
//    func getCountry() {
//        getMyCountry()
//        guard countryName.isNotEmpty else { return }
//                guard countryName.isNotEmpty else { return }
//                dataService?.getCountry(countryName: countryName, completion: {[weak self] result in
//                    switch result {
//                    case .success(let country):
//                        self?.country = country
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                })
//    }
//    
//    private func getMyCountry() {
//        userDefaultsManager?.getMyCountry(completion: { [weak self] result in
//            switch result {
//            case .success(let country):
//                let countryName = country.slug.capitalized
//                self?.countryName = countryName
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        })
//    }
//}
//
//extension MyCountryViewModel {
//    func getChartAndTotalValue(_ type: MyCountryDataType) {
//        if country.isNotEmpty {
//            chartAndTotalValue = (getCharts(type, country: country), getTotalValue(type, country: country), type)
//        } else {
//            chartAndTotalValue = ([], 0, .confirmed)
//        }
//    }
//
//    private func getTotalValue(_ type: MyCountryDataType, country: [DetailCountry]) -> Int {
//        switch type {
//        case .confirmed: return country.map { $0.confirmed }.reduce(0, +)
//        case .recovered: return country.map { $0.recovered }.reduce(0, +)
//        case .active: return country.map { $0.active }.reduce(0, +)
//        case .death: return country.map { $0.deaths }.reduce(0, +)
//        }
//    }
//
//    private func getCharts(_ type: MyCountryDataType, country: [DetailCountry]) -> [Chart] {
//        switch type {
//        case .confirmed: return country.map { Chart(value: $0.confirmed, text: $0.date) }
//        case .recovered: return country.map { Chart(value: $0.recovered, text: $0.date) }
//        case .active: return country.map { Chart(value: $0.active, text: $0.date) }
//        case .death: return country.map { Chart(value: $0.deaths, text: $0.date) }
//        }
//    }
//}
// swiftlint:enable comment_spacing
