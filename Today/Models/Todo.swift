//
//  Todo.swift
//  Today
//
//  Created by Sarah Reichelt on 17/1/2023.
//

import Foundation

struct Todo: Identifiable, Equatable, Hashable, Codable {
  var id = UUID()
  var order: Int
  var title: String
  var isComplete = false

  var sortProperty: Int {
    order + (isComplete ? 10000 : 0)
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
