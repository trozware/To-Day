//
//  AppState.swift
//  To-Day
//
//  Created by Sarah Reichelt on 20/1/2023.
//

import SwiftUI

// MARK: - Properties

class AppState: ObservableObject {
  var dataStore = DataStore()

  @Published var todos: [Todo] = DataStore().loadTodos()
  @Published var todoBeingEdited: Todo? {
    didSet {
      if let todoBeingEdited, todoBeingEdited.order == 1 {
        // hack to allow shift-tabbing into first todo field
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.checkForSelection(savedTodoId: todoBeingEdited.id)
        }
      }
    }
  }

  @AppStorage("sortCompletedToEnd") var sortCompletedToEnd = true

  func checkForSelection(savedTodoId: UUID) {
    if savedTodoId != todoBeingEdited?.id {
      self.todoBeingEdited = self.todos.first
    } else {
    }
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

  func move(_ todo: Todo, direction: MoveDirection) {
    let todoIndex = todos.firstIndex {
      $0.id == todo.id
    }

    if direction == .up {
      guard let todoIndex, todoIndex > 0 else {
        return
      }

      todos[todoIndex].order -= 1
      todos[todoIndex - 1].order += 1
    } else {
      guard let todoIndex, todoIndex < todos.count - 1 else {
        return
      }

      todos[todoIndex].order += 1
      todos[todoIndex + 1].order -= 1
    }

    todos.sort(using: KeyPathComparator(\.order))

    // if this is done immediately, the focus doesn't move with the todo
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.todoBeingEdited = todo
    }

    saveData()
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
    dataStore.saveTodos(todos: todos)
  }
}
