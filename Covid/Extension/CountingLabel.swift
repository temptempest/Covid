//
//  CountingLabel.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

final class CountingLabel: UILabel {
    enum CounterAnimationType {
        case animationLinear
        case animationEasyIn
        case animationEasyOut
    }
    private let counterVelocity: Float = 3
    private var startNumber: Float = 0.0
    private var endNumber: Float = 0.0
    private var progress: TimeInterval = .init()
    private var duration: TimeInterval  = .init()
    private var lastUpdate: TimeInterval = .init()
    private var timer: Timer?
    private var counterAnimationType: CounterAnimationType = .animationLinear
    private var withPlus: Bool = false
    private var currentCounterValue: Float {
        if progress >= duration {
            return endNumber
        }
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        return startNumber + (update * (endNumber - startNumber))
    }
    /// Animate number
    /// - Parameters:
    ///   - fromValue: first value
    ///   - toValue: last value
    ///   - duration: duration in seconds
    ///   - animationType: tpe of animation
    ///   - withPlus: with or without + symbol at the beginning
    func count(fromValue: Int, toValue: Int,
               withDuration duration: TimeInterval,
               andAnimationType animationType: CounterAnimationType,
               withPlus: Bool) {
        startNumber = Float(fromValue)
        endNumber = Float(toValue)
        self.duration = duration
        counterAnimationType = animationType
        self.withPlus = withPlus
        progress = 0
        lastUpdate = Date.timeIntervalSinceReferenceDate
        invalidateTimer()
        if duration == 0 {
            updateText(value: Int(toValue))
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                     selector: #selector(updateValue), userInfo: nil, repeats: true)
    }
    @objc
    private func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        // swiftlint:disable shorthand_operator
        progress = progress + (now - lastUpdate)
        // swiftlint:enable shorthand_operator
        lastUpdate = now
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        // updateText in label
        updateText(value: Int(currentCounterValue))
    }
    private func updateText(value: Int) {
        if withPlus == true {
            text = "+ \(value.formattedWithSeparator)"
        } else {
            text = value.formattedWithSeparator
        }
    }
    private func updateCounter(counterValue: Float) -> Float {
        switch counterAnimationType {
        case .animationLinear:
            return counterValue
        case .animationEasyIn:
            return powf(counterValue, counterVelocity)
        case .animationEasyOut:
            return 1 - powf(1.0 - counterValue, counterVelocity)
        }
    }
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self).emptyStringIfEmpty
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
