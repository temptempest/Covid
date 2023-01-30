////
////  MyCVC.swift
////  Covid
////
////  Created by temptempest on 19.12.2022.
////
// swiftlint:disable comment_spacing
//import UIKit
//import SnapKit
//import Combine
//
//final class MyCountryViewController: UIViewController {
//    private var cancellables: Set<AnyCancellable> = []
//    
//    var viewModel: MyCountryViewModelDelegate? {
//        didSet {
//            viewModel?.publisher
//                .receive(on: RunLoop.main)
//                .sink { [weak self] (countries) in
//                    guard countries.isNotEmpty,
//                          let self else { return }
//                    self.viewModel?.getChartAndTotalValue(.confirmed)
//                    self.viewModel?.getChartAndTotalValue(.recovered)
//                    self.viewModel?.getChartAndTotalValue(.active)
//                    self.viewModel?.getChartAndTotalValue(.death)
//                }.store(in: &cancellables)
//            
//            viewModel?.chartAndTotalValuePublisher
//                .receive(on: RunLoop.main)
//                .sink { [weak self] (charts, totalValue, type) in
//                    guard charts.isNotEmpty,
//                          let self
//                    else { self?.perform(.clearAllCharts); return }
//                    OperationQueue.main.addOperation {
//                        self.confirmedChartsLineView.noDataText = Constants.loadingText
//                        switch type {
//                        case .confirmed:
//                            self.perform(.setConfirmedChartsLineView(charts: charts, total: totalValue))
//                        case .recovered:
//                            self.perform(.setRecoveredChartsLineView(charts: charts, total: totalValue))
//                        case .active:
//                            self.perform(.setActiveChartsLineView(charts: charts, total: totalValue))
//                        case .death:
//                            self.perform(.setDeathChartsLineView(charts: charts, total: totalValue))
//                        }
//                    }
//                }.store(in: &cancellables)
//            
//            viewModel?.countryNamePublisher
//                .receive(on: RunLoop.main)
//                .sink { [weak self] (country) in
//                    guard country.isNotEmpty else { return }
//                    self?.countryLabel.text = country
//                }.store(in: &cancellables)
//        }
//    }
//    
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = UIColor.theme.background
//        scrollView.alwaysBounceVertical = true
//        return scrollView
//    }()
//    private lazy var statisticStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews:
//                                        [confirmedChartsLineView, recoveredChartsLineView,
//                                         activeChartsLineView, deathChartsLineView])
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 5
//        return stackView
//    }()
//    private lazy var countryLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
//        label.textColor = UIColor.theme.blue
//        return label
//    }()
//    
//    private lazy var confirmedChartsLineView = ChartLineView()
//    private lazy var recoveredChartsLineView = ChartLineView()
//    private lazy var activeChartsLineView = ChartLineView()
//    private lazy var deathChartsLineView = ChartLineView()
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        [.clearAllCharts, .updateCountry].forEach(perform)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        confirmedChartsLineView.noDataText = Constants.setCountry
//        recoveredChartsLineView.noDataText = ""
//        activeChartsLineView.noDataText = ""
//        deathChartsLineView.noDataText = ""
//        
//        [.setupViews, .setupConstraints].forEach(perform)
//    }
//    
//    private func setupViews() {
//        view.backgroundColor = UIColor.theme.background
//        view.addSubview(scrollView)
//        scrollView.addSubview(statisticStackView)
//        scrollView.addSubview(countryLabel)
//    }
//    
//    private func setupConstraints() {
//        scrollView.snp.makeConstraints {
//            $0.leading.trailing.bottom.equalToSuperview()
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//        }
//        countryLabel.snp.makeConstraints {
//            $0.top.equalTo(scrollView.snp.top).offset(10)
//            $0.leading.equalTo(scrollView.snp.leading).offset(16)
//            $0.trailing.equalTo(scrollView.snp.trailing)
//            $0.height.equalTo(35)
//        }
//        statisticStackView.snp.makeConstraints {
//            $0.top.equalTo(countryLabel.snp.bottom).offset(10)
//            $0.leading.equalTo(scrollView.snp.leading).offset(16)
//            $0.trailing.equalTo(view.snp.trailing).offset(-16)
//            $0.height.equalTo(600)
//        }
//    }
//    
//    private func updateCountry() {
//        viewModel?.getCountry()
//    }
//    private func clearAllCharts() {
//        self.confirmedChartsLineView.clear()
//        self.recoveredChartsLineView.clear()
//        self.activeChartsLineView.clear()
//        self.deathChartsLineView.clear()
//    }
//}
//
//extension MyCountryViewController {
//    private enum MyCountryCardsAction {
//        case setupViews
//        case setupConstraints
//        case updateCountry
//        case setConfirmedChartsLineView(charts: [Chart], total: Int)
//        case setRecoveredChartsLineView(charts: [Chart], total: Int)
//        case setActiveChartsLineView(charts: [Chart], total: Int)
//        case setDeathChartsLineView(charts: [Chart], total: Int)
//        case clearAllCharts
//    }
//    private func perform(_ action: MyCountryCardsAction) {
//        switch action {
//        case .setupViews: setupViews()
//        case .setupConstraints: setupConstraints()
//        case .updateCountry: updateCountry()
//        case .setConfirmedChartsLineView(charts: let charts, total: let total):
//            confirmedChartsLineView
//                .configure(charts: charts, label: Constants.totalConfirmed + ": \(total)", color: UIColor.theme.blue)
//        case .setRecoveredChartsLineView(charts: let charts, total: let total):
//            recoveredChartsLineView
//                .configure(charts: charts, label: Constants.totalRecovered + ": \(total)", color: UIColor.theme.green)
//        case .setActiveChartsLineView(charts: let charts, total: let total):
//            activeChartsLineView
//                .configure(charts: charts, label: Constants.totalActive + ": \(total)", color: UIColor.theme.orange)
//        case .setDeathChartsLineView(charts: let charts, total: let total):
//            deathChartsLineView
//                .configure(charts: charts, label: Constants.totalDeath + ": \(total)", color: UIColor.theme.red)
//        case .clearAllCharts: clearAllCharts()
//        }
//    }
//}
//
// swiftlint:enable comment_spacing
