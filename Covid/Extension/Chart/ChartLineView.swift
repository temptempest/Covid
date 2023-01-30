//
//  ChartLineView.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit
import Charts

final class ChartLineView: LineChartView, ChartViewDelegate {
    var dateArray: [String] = []
    func configure(charts: [Chart], label: String, color: UIColor, showLoadingText: Bool = false) {
        delegate = self
        let entries = charts.enumerated().map { index, element in
            let entry = ChartDataEntry(x: Double(index), y: Double(element.value))
            dateArray.append(element.text)
            return entry
        }
        let set = LineChartDataSet(entries: entries, label: label)
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 3
        set.setColor(color)
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        self.data = data
        setDateAndHideUnnecessaryInformation()
    }
}

extension ChartLineView {
    private func setDateAndHideUnnecessaryInformation() {
        rightAxis.enabled = false
        leftAxis.enabled = true
        leftAxis.valueFormatter = YAxisValueFormatter()
        xAxis.enabled = true
        xAxis.valueFormatter = xAxisValueFormatter(dateArray)
        isUserInteractionEnabled = false
    }
}
