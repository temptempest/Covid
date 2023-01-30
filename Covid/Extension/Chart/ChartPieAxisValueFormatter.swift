//
//  ChartPieAxisValueFormatter.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Charts
import UIKit

func xAxisValueFormatter(_ arr: [String]) -> DefaultAxisValueFormatter {
    var dateFormatterFrom = DateFormatter.getFormattedDate(format: .heavy)
    var dateFormatterTo = DateFormatter.getFormattedDate(format: .yearMonth)
    if (arr[safe: 0]?.count).zeroIfEmpty < 24 {
        dateFormatterFrom = DateFormatter.getFormattedDate(format: .long)
        dateFormatterTo = DateFormatter.getFormattedDate(format: .yearMonthDay)
    }
    return DefaultAxisValueFormatter(block: { (index, _) in
        let str = arr[Int(index)]
        guard let date = dateFormatterFrom.date(from: str) else {return ""}
        return dateFormatterTo.string(from: date)
    })
}

/// Class to format Y axis in Charts. X axis shows big values in KMBTPE format. For example 1000 - 1K
final class YAxisValueFormatter: IndexAxisValueFormatter {
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return Int(value).abbreviated
    }
}

extension Int {
    var abbreviated: String {
        let abbrev = "KMBTPE"
        return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
        } ?? String(self)
    }
}
