//
//  ChartPieView.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Charts
import UIKit

final class ChartPieView: PieChartView, ChartViewDelegate {
    func configure(charts: [Chart], label: String) {
        delegate = self
        let entries = charts.enumerated().map { _, element in
            let entry = PieChartDataEntry(value: Double(element.value), label: element.text)
            return entry
        }
        let set = PieChartDataSet(entries: entries, label: label)
        set.colors = [
            UIColor.theme.green,
            UIColor.theme.yellow,
            UIColor.theme.red,
            UIColor.theme.blue
        ]
        data = PieChartData(dataSet: set)
        hideUnnecessaryInformation()
    }
}

extension ChartPieView {
    private func hideUnnecessaryInformation() {
        holeRadiusPercent = 0
        transparentCircleColor = UIColor.clear
        isUserInteractionEnabled = false
    }
}
