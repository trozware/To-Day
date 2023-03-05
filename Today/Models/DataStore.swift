//
//  DataStore.swift
//  Today
//
//  Created by Sarah Reichelt on 17/1/2023.
//

import Foundation

struct DataStore {
  let fileURL = URL.documentsDirectory.appending(component: "todos.json")

  func saveTodos(todos: [Todo]) {
    do {
      let data = try JSONEncoder().encode(todos)
      try data.write(to: fileURL)
    } catch {
      print(error)
    }
  }

  func loadTodos() -> [Todo] {
    do {
      let data = try Data(contentsOf: fileURL)
      let todos = try JSONDecoder().decode([Todo].self, from: data)
        .sorted(using: KeyPathComparator(\.order))
      return todos
    } catch {
      print(error)
    }

    return Todo.sampleToDos
  }
}
