//
//  MyCountryViewController.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import SnapKit

final class MyCountryViewController: UIViewController {
    var viewModel: MyCountryViewModelDelegate? {
        didSet {
            viewModel?.updateHandler = { [weak self] _ in
                guard
                    let (confirmedCharts, confirmedTotal) = self?.viewModel?.getChartAndTotalValue(.confirmed),
                    let (recoveredCharts, recoveredTotal) = self?.viewModel?.getChartAndTotalValue(.recovered),
                    let (activeCharts, activeTotal) = self?.viewModel?.getChartAndTotalValue(.active),
                    let (deathCharts, deathTotal) = self?.viewModel?.getChartAndTotalValue(.death),
                    confirmedCharts.isNotEmpty,
                    let self
                else { self?.perform(.clearAllCharts); return }
                OperationQueue.mainAsyncIfNeeded {
                    self.confirmedChartsLineView.noDataText = Constants.loadingText
                    [.setConfirmedChartsLineView(charts: confirmedCharts, total: confirmedTotal),
                     .setRecoveredChartsLineView(charts: recoveredCharts, total: recoveredTotal),
                     .setActiveChartsLineView(charts: activeCharts, total: activeTotal),
                     .setDeathChartsLineView(charts: deathCharts, total: deathTotal)].forEach(self.perform)
                }
            }
            viewModel?.updateNameHandler = { [weak self] countryName in
                guard let self else { return }
                var name = countryName
                if name == "" {
                    name = Constants.notSetCountry
                }
                OperationQueue.mainAsyncIfNeeded {
                    self.countryLabel.text = name
                }
            }
        }
    }
    
    private lazy var statisticStackViewHeight: CGFloat = Support.isIphoneSEFirstGeneration ? 450 : 600
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.theme.background
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private lazy var statisticStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
                                        [confirmedChartsLineView, recoveredChartsLineView,
                                         activeChartsLineView, deathChartsLineView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.theme.myCountry.countryLabel
        label.textColor = UIColor.theme.blue
        return label
    }()
    
    private lazy var confirmedChartsLineView = ChartLineView()
    private lazy var recoveredChartsLineView = ChartLineView()
    private lazy var activeChartsLineView = ChartLineView()
    private lazy var deathChartsLineView = ChartLineView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [.clearAllCharts, .updateCountry].forEach(perform)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmedChartsLineView.noDataText = Constants.setCountry
        recoveredChartsLineView.noDataText = ""
        activeChartsLineView.noDataText = ""
        deathChartsLineView.noDataText = ""
        
        [.setupViews, .setupConstraints].forEach(perform)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.theme.background
        view.addSubview(scrollView)
        scrollView.addSubview(statisticStackView)
        scrollView.addSubview(countryLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        countryLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(16)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.height.equalTo(35)
        }
        statisticStackView.snp.makeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(statisticStackViewHeight)
        }
    }
    
    private func updateCountry() {
        viewModel?.getCountry()
    }
    private func clearAllCharts() {
        confirmedChartsLineView.clear()
        recoveredChartsLineView.clear()
        activeChartsLineView.clear()
        deathChartsLineView.clear()
    }
}

// MARK: - ALL ACTIONS
extension MyCountryViewController {
    private enum MyCountryCardsAction {
        case setupViews
        case setupConstraints
        case updateCountry
        case setConfirmedChartsLineView(charts: [Chart], total: Int)
        case setRecoveredChartsLineView(charts: [Chart], total: Int)
        case setActiveChartsLineView(charts: [Chart], total: Int)
        case setDeathChartsLineView(charts: [Chart], total: Int)
        case clearAllCharts
    }
    private func perform(_ action: MyCountryCardsAction) {
        switch action {
        case .setupViews: setupViews()
        case .setupConstraints: setupConstraints()
        case .updateCountry: updateCountry()
        case .setConfirmedChartsLineView(charts: let charts, total: let total):
            confirmedChartsLineView
                .configure(charts: charts, label: Constants.totalConfirmed + ": \(total)", color: UIColor.theme.blue)
        case .setRecoveredChartsLineView(charts: let charts, total: let total):
            recoveredChartsLineView
                .configure(charts: charts, label: Constants.totalRecovered + ": \(total)", color: UIColor.theme.green)
        case .setActiveChartsLineView(charts: let charts, total: let total):
            activeChartsLineView
                .configure(charts: charts, label: Constants.totalActive + ": \(total)", color: UIColor.theme.orange)
        case .setDeathChartsLineView(charts: let charts, total: let total):
            deathChartsLineView
                .configure(charts: charts, label: Constants.totalDeath + ": \(total)", color: UIColor.theme.red)
        case .clearAllCharts: clearAllCharts()
        }
    }
}

// MARK: Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct MyCountryViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let dependency = DependenciesMock()
        let viewController = UINavigationController(rootViewController: MyCountryAssembly.configure(dependency))
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
