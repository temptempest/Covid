//
//  StatisticView.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

final class StatisticView: UIView {
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.background
        label.font = UIFont.theme.statistic.title
        label.textAlignment = .left
        return label
    }()
    private lazy var topCounterLabel: CountingLabel = {
        let label = CountingLabel()
        label.textAlignment = .right
        label.font = UIFont.theme.statistic.counter
        label.textColor = UIColor.theme.background
        return label
    }()
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.theme.statistic.title
        label.textAlignment = .left
        label.textColor = UIColor.theme.background
        return label
    }()
    private lazy var bottomCounterLabel: CountingLabel = {
        let label = CountingLabel()
        label.textAlignment = .right
        label.font = UIFont.theme.statistic.counter
        label.textColor = UIColor.theme.background
        return label
    }()
    
    func configure(top: StatisticViewType,
                   bottom: StatisticViewType, backgroundColor: UIColor) {
        topLabel.text = top.string
        topCounterLabel.count(fromValue: 0, toValue: top.value,
                              withDuration: 0.8, andAnimationType: .animationLinear,
                              withPlus: top.value > 0 ? true : false)
        bottomLabel.text = bottom.string
        bottomCounterLabel.count(fromValue: 0, toValue: bottom.value,
                                 withDuration: 0.8, andAnimationType: .animationLinear,
                                 withPlus: bottom.value > 0 ? true : false)
        topCounterLabel.textColor = top.color
        bottomCounterLabel.textColor = bottom.color
        self.backgroundColor = backgroundColor
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        addSubview(topCounterLabel)
        topCounterLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.trailing.equalTo(snp.trailing).offset(-16)
            $0.height.equalTo(40)
        }
        addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.leading.equalTo(snp.leading).offset(16)
            $0.trailing.equalTo(topCounterLabel.snp.leading)
            $0.bottom.equalTo(topCounterLabel.snp.bottom)
        }
        addSubview(bottomCounterLabel)
        bottomCounterLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(topLabel.snp.bottom)
        }
        addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints {
            $0.leading.equalTo(topLabel.snp.leading)
            $0.trailing.equalTo(topLabel.snp.trailing)
            $0.top.equalTo(topLabel.snp.bottom)
        }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct StatisticViewPreview: PreviewProvider {
    static var previews: some View {
        let statisticBlueView = StatisticView.getMock(UIColor.theme.blue)
        let statisticGreenView = StatisticView.getMock(UIColor.theme.green)
        let statisticRedView = StatisticView.getMock(UIColor.theme.red)
        
        let size = CGSize(width: UIScreen.main.bounds.width - 32, height: 80)
        Group {
            PreviewView(statisticBlueView)
                .previewDisplayName("Blue")
            PreviewView(statisticBlueView)
                .previewDisplayName("Dark_Blue")
                .preferredColorScheme(.dark)
            PreviewView(statisticGreenView)
                .previewDisplayName("Green")
            PreviewView(statisticGreenView)
                .previewDisplayName("Dark_Green")
                .preferredColorScheme(.dark)
            PreviewView(statisticRedView)
                .previewDisplayName("Red")
            PreviewView(statisticRedView)
                .previewDisplayName("Dark_Red")
                .preferredColorScheme(.dark)
        }
        .frame(width: size.width,
               height: size.height)
    }
}

// MARK: Mock StatisticView
extension StatisticView {
    static func getMock(_ color: UIColor) -> StatisticView {
        StatisticView().configureMockView(color)
    }
    
    func showSkeleton() -> Self {
        showSkeleton(backgroundColor: backgroundColor!, highlightColor: backgroundColor!.lighter()!)
        return self
    }
    private func configureMockView(_ backgroundColor: UIColor) -> StatisticView {
        self.configure(
            top: .init(string: Constants.totalConfirmed,
                       value: 10000,
                       color: UIColor.theme.background),
            bottom: .init(string: Constants.newConfirmed,
                          value: 5000,
                          color: UIColor.theme.background),
            backgroundColor: backgroundColor)
        return self
    }
}
#endif
