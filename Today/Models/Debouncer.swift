//
//  Debouncer.swift
//  To-Day
//
//  Created by Sarah Reichelt on 5/3/2023.
//

import Foundation

public class Debouncer {
  private let timeInterval: TimeInterval
  private var timer: Timer?

  typealias Handler = () -> Void
  var handler: Handler?

  init(timeInterval: TimeInterval) {
    self.timeInterval = timeInterval
  }

  public func renewInterval() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(
      withTimeInterval: timeInterval,
      repeats: false) { [weak self] (timer) in
        self?.timeIntervalDidFinish(for: timer)
      }
  }

  @objc private func timeIntervalDidFinish(for timer: Timer) {
    guard timer.isValid else {
      return
    }

    handler?()
    handler = nil
  }
}
