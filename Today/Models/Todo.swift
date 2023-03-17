//
//  Todo.swift
//  Today
//
//  Created by Sarah Reichelt on 17/1/2023.
//

import AppKit

struct Todo: Identifiable, Equatable, Hashable, Codable {
  var id = UUID()
  var order: Int
  var title: String
  var isComplete = false

  var sortProperty: Int {
    order + (isComplete ? 10000 : 0)
  }

  var wrappedTitle: String {
    let words = title.components(separatedBy: .whitespaces)
    var wrapped: [String] = [""]
    let maxWidth: CGFloat = 250
    let font = NSFont.menuBarFont(ofSize: 0)
    let attributes: [NSAttributedString.Key: Any] = [.font: font]

    for word in words {
      let index = wrapped.count - 1
      let testString = wrapped[index] + " " + word
      let testAttrib = NSAttributedString(string: testString, attributes: attributes)
      let length = testAttrib.size().width
      if length > maxWidth {
        wrapped.append(word)
      } else {
        wrapped[index] += " " + word
      }
    }

    let wrappedString = wrapped.joined(separator: "\n").trimmingCharacters(in: .whitespaces)
    return wrappedString
  }
}

extension Todo {
  static var sampleToDos: [Todo] {
    [
      Todo(order: 1, title: "Edit the todos"),
      Todo(order: 2, title: "Add new one"),
      Todo(order: 3, title: "Only for today"),
      Todo(order: 4, title: "Check off progress")
    ]
  }
}
