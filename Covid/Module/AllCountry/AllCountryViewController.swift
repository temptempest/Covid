//
//  AllCountryViewController.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import SnapKit

final class AllCountryViewController: UIViewController {
    var viewModel: AllCountryViewModelDelegate? {
        didSet {
            viewModel?.updateSummaryHandler = { [weak self] summary in
                let totalConfirmed = summary.global.totalConfirmed
                let newConfirmed = summary.global.newConfirmed
                let totalRecovered = summary.global.totalRecovered
                let newRecovered = summary.global.newRecovered
                let totalDeaths = summary.global.totalDeaths
                let newDeaths = summary.global.newDeaths
                guard let self,
                      let topTotalDeath = self.viewModel?.getTopTotalDeathCountryCharts(),
                      totalConfirmed > 0
                else { return }
                OperationQueue.mainAsyncIfNeeded {
                    [.setConfirmedStatisticView(total: totalConfirmed, new: newConfirmed),
                     .setRecoveredStatisticView(total: totalRecovered, new: newRecovered),
                     .setDeathsStatisticView(total: totalDeaths, new: newDeaths),
                     .setTopTotalDeathCountryChart(charts: topTotalDeath)].forEach(self.perform)
                    self.perform(.hideLoadingAnimations)
                }
            }
            viewModel?.updateChartsHandler = { [weak self] _ in
                guard
                    let totalConfirmed = self?.viewModel?.getTotalChart(.totalConfirmed),
                    let totalRecovered = self?.viewModel?.getTotalChart(.totalRecovered),
                    let totalDeath = self?.viewModel?.getTotalChart(.totalDeath),
                    let newConfirmed = self?.viewModel?.getTotalChart(.newConfirmed),
                    let newRecovered = self?.viewModel?.getTotalChart(.newRecovered),
                    let newDeath = self?.viewModel?.getTotalChart(.newDeath),
                    let self
                else { return }
                OperationQueue.mainAsyncIfNeeded {
                    [.setTotalConfirmedCharts(charts: totalConfirmed),
                     .setTotalRecoveredCharts(charts: totalRecovered),
                     .setTotalDeathCharts(charts: totalDeath),
                     .setNewConfirmedCharts(charts: newConfirmed),
                     .setNewRecoveredCharts(charts: newRecovered),
                     .setNewDeathCharts(charts: newDeath)].forEach(self.perform)
                }
            }
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.theme.background
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var topTotalDeathLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.topTotalDeath
        label.font = UIFont.theme.allCountry.section
        label.textColor = UIColor.theme.red
        return label
    }()
    
    private lazy var statisticStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
                                        [confirmedStatisticView, totalConfirmedChartsLineView, newConfirmedChartsLineView,
                                         recoveredStatisticView, totalRecoveredChartsLineView, newRecoveredChartsLineView,
                                         deathsStatisticView, totalDeathChartsLineView, newDeathChartsLineView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var confirmedStatisticView = StatisticView()
    private lazy var recoveredStatisticView = StatisticView()
    private lazy var deathsStatisticView = StatisticView()
    private lazy var totalConfirmedChartsLineView = ChartLineView()
    private lazy var totalRecoveredChartsLineView = ChartLineView()
    private lazy var totalDeathChartsLineView = ChartLineView()
    private lazy var newConfirmedChartsLineView = ChartLineView()
    private lazy var newRecoveredChartsLineView = ChartLineView()
    private lazy var newDeathChartsLineView = ChartLineView()
    private lazy var chartCountryPieView = ChartPieView()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1500)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [.showLoadingAnimations, .getSummary, .getChartsData].forEach(perform)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        perform(.hideLoadingAnimations)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalConfirmedChartsLineView.noDataText = Constants.loadingText
        totalRecoveredChartsLineView.noDataText = Constants.loadingText
        totalDeathChartsLineView.noDataText = Constants.loadingText
        newConfirmedChartsLineView.noDataText = Constants.loadingText
        newRecoveredChartsLineView.noDataText = Constants.loadingText
        newDeathChartsLineView.noDataText = Constants.loadingText
        
        [.setupViews, .setupConstraints].forEach(perform)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.theme.background
        view.addSubview(scrollView)
        scrollView.addSubview(statisticStackView)
        scrollView.addSubview(topTotalDeathLabel)
        scrollView.addSubview(chartCountryPieView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        statisticStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(800)
        }
        topTotalDeathLabel.snp.makeConstraints {
            $0.top.equalTo(statisticStackView.snp.bottom).offset(10)
            $0.leading.equalTo(statisticStackView.snp.leading)
            $0.trailing.equalTo(statisticStackView.snp.trailing)
            $0.height.equalTo(22)
        }
        chartCountryPieView.snp.makeConstraints {
            $0.top.equalTo(topTotalDeathLabel.snp.bottom).offset(-5)
            $0.leading.equalTo(statisticStackView.snp.leading)
            $0.trailing.equalTo(statisticStackView.snp.trailing)
            $0.height.equalTo(self.view.bounds.width)
        }
    }
}

// MARK: - Animations
extension AllCountryViewController {
    private func showLoadingAnimations() {
        confirmedStatisticView.showSkeleton(backgroundColor: UIColor.theme.blue,
                                            highlightColor: UIColor.theme.blueLighter)
        recoveredStatisticView.showSkeleton(backgroundColor: UIColor.theme.green,
                                            highlightColor: UIColor.theme.greenLighter)
        deathsStatisticView.showSkeleton(backgroundColor: UIColor.theme.red,
                                         highlightColor: UIColor.theme.redLighter)
    }
    private func hideLoadingAnimations() {
        confirmedStatisticView.hideSkeleton()
        recoveredStatisticView.hideSkeleton()
        deathsStatisticView.hideSkeleton()
    }
}

// MARK: - ALL ACTIONS
extension AllCountryViewController {
    private enum AllCountryAction {
        case getSummary
        case getChartsData
        case setupViews
        case setupConstraints
        case showLoadingAnimations
        case hideLoadingAnimations
    }
    
    private enum AllCountryCardsAction {
        case setTopTotalDeathCountryChart(charts: [Chart])
        case setTotalConfirmedCharts(charts: [Chart])
        case setTotalRecoveredCharts(charts: [Chart])
        case setTotalDeathCharts(charts: [Chart])
        case setNewConfirmedCharts(charts: [Chart])
        case setNewRecoveredCharts(charts: [Chart])
        case setNewDeathCharts(charts: [Chart])
        case setConfirmedStatisticView(total: Int, new: Int)
        case setRecoveredStatisticView(total: Int, new: Int)
        case setDeathsStatisticView(total: Int, new: Int)
    }
    
    private func perform(_ action: AllCountryAction) {
        switch action {
        case .getSummary: viewModel?.getSummary()
        case .getChartsData: viewModel?.getChartsData()
        case .setupViews: setupViews()
        case .setupConstraints: setupConstraints()
        case .showLoadingAnimations: showLoadingAnimations()
        case .hideLoadingAnimations: hideLoadingAnimations()
        }
    }
    
    private func perform(_ action: AllCountryCardsAction) {
        switch action {
        case .setConfirmedStatisticView(let total, let new):
            confirmedStatisticView.configure(
                top: .init(string: Constants.totalConfirmed, value: total, color: UIColor.theme.background),
                bottom: .init(string: Constants.newConfirmed, value: new,
                              color: UIColor.theme.background), backgroundColor: UIColor.theme.blue)
        case .setRecoveredStatisticView(let total, let new):
            recoveredStatisticView.configure(
                top: .init(string: Constants.totalRecovered, value: total, color: UIColor.theme.background),
                bottom: .init(string: Constants.newRecovered, value: new,
                              color: UIColor.theme.background), backgroundColor: UIColor.theme.green)
        case .setDeathsStatisticView(let total, let new):
            deathsStatisticView.configure(
                top: .init(string: Constants.totalDeath, value: total, color: UIColor.theme.background),
                bottom: .init(string: Constants.newDeath, value: new, color: UIColor.theme.background), backgroundColor: UIColor.theme.red)
        case .setTopTotalDeathCountryChart(charts: let charts):
            chartCountryPieView.configure(charts: charts, label: "")
        case .setTotalConfirmedCharts(charts: let charts):
            totalConfirmedChartsLineView.configure(charts: charts, label: Constants.totalConfirmed, color: UIColor.theme.blue)
        case .setTotalRecoveredCharts(charts: let charts):
            totalRecoveredChartsLineView
                .configure(charts: charts, label: Constants.totalRecovered, color: UIColor.theme.green)
        case .setTotalDeathCharts(charts: let charts):
            totalDeathChartsLineView
                .configure(charts: charts, label: Constants.totalDeath, color: UIColor.theme.red)
        case .setNewConfirmedCharts(charts: let charts):
            newConfirmedChartsLineView
                .configure(charts: charts, label: Constants.newConfirmed, color: UIColor.theme.blue.withAlphaComponent(0.5))
        case .setNewRecoveredCharts(charts: let charts):
            newRecoveredChartsLineView
                .configure(charts: charts, label: Constants.newRecovered, color: UIColor.theme.green.withAlphaComponent(0.5))
        case .setNewDeathCharts(charts: let charts):
            newDeathChartsLineView
                .configure(charts: charts, label: Constants.newDeath, color: UIColor.theme.red.withAlphaComponent(0.5))
        }
    }
}

// MARK: Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct AllCountryViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let dependency = DependenciesMock()
        let viewController = UINavigationController(rootViewController: AllCountryAssembly.configure(dependency))
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
