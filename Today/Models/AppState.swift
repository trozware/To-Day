//
//  AppState.swift
//  To-Day
//
//  Created by Sarah Reichelt on 20/1/2023.
//

import SwiftUI

// MARK: - Properties

class AppState: ObservableObject {
  @Published var todos: [Todo] = DataStore().loadTodos() {
    didSet {
      debouncedSave()
    }
  }
  
  @AppStorage("sortCompletedToEnd") var sortCompletedToEnd = true

  var dataStore = DataStore()
  var saveTask: DispatchWorkItem?

  func debouncedSave() {
    self.saveTask?.cancel()

    let task = DispatchWorkItem { [weak self] in
      DispatchQueue.global(qos: .background).async { [weak self] in
        print("Saving after debounce")
        if let self {
          self.dataStore.saveTodos(todos: self.todos)
        }
      }
    }

    self.saveTask = task
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
  }
}

// MARK: - Computed Properties

extension AppState {
  var sortedTodos: [Todo] {
    if sortCompletedToEnd {
      return todos.sorted(using: KeyPathComparator(\.sortProperty))
    } else {
      return todos.sorted(using: KeyPathComparator(\.order))
    }
  }

  var allComplete: Bool {
    let totalTodos = todos.count
    let completedTodos = todos.filter { $0.isComplete }.count
    return totalTodos == completedTodos
  }

  var allIncomplete: Bool {
    let completedTodos = todos.filter { $0.isComplete }.count
    return completedTodos == 0
  }

  var todoButtons: some View {
    ForEach(sortedTodos) { todo in
      Button {
        self.toggleComplete(todo.id)
      } label: {
        if todo.isComplete {
          Text(todo.title)
            .foregroundColor(.secondary)
            .strikethrough()
        } else {
          Text(todo.title)
        }
      }
    }
  }

  var menuTitle: some View {
    let title: String
    let imageName: String

    let totalTodos = todos.count
    let completedTodos = todos.filter { $0.isComplete }.count

    if totalTodos == 0 {
      title = "To-Day"
      imageName = "list.bullet.clipboard"
    } else if completedTodos == totalTodos {
      title = "To-Day: complete"
      imageName = "checklist.checked"
    } else {
      title = "To-Day: \(completedTodos) of \(totalTodos) done"
      if completedTodos == 0 {
        imageName = "checklist.unchecked"
      } else {
        imageName = "checklist"
      }
    }

    return HStack {
      Image(systemName: imageName)
      Text(title).monospacedDigit()
    }
  }
}

// MARK: - Methods

extension AppState {
  func createNewTodo(title: String) {
    let newTodo = Todo(order: todos.count + 1, title: title)
    todos.append(newTodo)
    saveData()
  }

  func deleteTodo(_ todo: Todo) {
    todos.removeAll {
      $0.id == todo.id
    }
    reassignOrders()
    saveData()
  }

  func deleteAll() {
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = "Really delete all the todos?"
    alert.addButton(withTitle: "Delete")
    alert.addButton(withTitle: "Cancel")

    NSApp.activate(ignoringOtherApps: true)

    let response = alert.runModal()
    if response == .alertFirstButtonReturn {
      todos = []
      saveData()
    }
  }

  func reassignOrders() {
    for todoIndex in 0 ..< todos.count {
      todos[todoIndex].order = todoIndex + 1
    }
  }

  func toggleComplete(_ id: UUID) {
    let todoIndex = todos.firstIndex {
      $0.id == id
    }
    if let todoIndex {
      todos[todoIndex].isComplete.toggle()
    }

    saveData()
  }

  func markAll(complete: Bool) {
    for index in 0 ..< todos.count {
      todos[index].isComplete = complete
    }
    saveData()
  }

  func saveData() {
    debouncedSave()
  }
}
