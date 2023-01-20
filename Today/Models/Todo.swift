//
//  Todo.swift
//  Today
//
//  Created by Sarah Reichelt on 17/1/2023.
//

import Foundation

struct Todo: Identifiable, Equatable, Codable {
  var id: Int
  var title: String
  var isComplete = false

  var sortProperty: Int {
    id + (isComplete ? 10000 : 0)
  }
}

extension Todo {
  static var sampleToDos: [Todo] {
    [
      Todo(id: 1, title: "Edit the todos"),
      Todo(id: 2, title: "Add new one"),
      Todo(id: 3, title: "Only for today"),
      Todo(id: 4, title: "Check off progress")
    ]
  }
}
