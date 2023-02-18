//
//  KeyCodes.swift
//  To-Day
//
//  Created by Sarah Reichelt on 17/2/2023.
//

import Foundation

enum KeyCodes {
  static var leftArrow: UInt16 = 123
  static var rightArrow: UInt16 = 124
  static var upArrow: UInt16 = 126
  static var downArrow: UInt16 = 125
  static var dKey: UInt16 = 2
  static var tabKey: UInt16 = 48
}

// swiftlint: disable identifier_name
enum MoveDirection {
  case up, down
}
// swiftlint: enable identifier_name
