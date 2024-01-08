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

  @AppStorage("completeHandling") var completeHandling = Completes.sortToEnd

  var dataStore = DataStore()
  var saveTask: DispatchWorkItem?

  func debouncedSave() {
    self.saveTask?.cancel()

    let task = DispatchWorkItem { [todos, weak self] in
      DispatchQueue.global(qos: .background).async { [weak self] in
        if let self {
          self.dataStore.saveTodos(todos: todos)
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
    switch completeHandling {
    case .doNothing, .moveToSubMenu:
      return todos.sorted(using: KeyPathComparator(\.order))
    case .sortToEnd:
      return todos.sorted(using: KeyPathComparator(\.sortProperty))
    case .hide, .delete:
      return todos
        .filter { !$0.isComplete }
        .sorted(using: KeyPathComparator(\.order))
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
    Group {
      if completeHandling == .moveToSubMenu {
        let pendingTodos = sortedTodos.filter { !$0.isComplete }
        let completeTodos = sortedTodos.filter { $0.isComplete }

        if !pendingTodos.isEmpty {
          ForEach(pendingTodos) { todo in
            Button {
              self.toggleComplete(todo.id)
            } label: {
              Text(todo.wrappedTitle)
            }
          }
        }

        Menu("Completed") {
          if completeTodos.isEmpty {
            Button {} label: {
              Text("No completed todos.")
            }
            .disabled(true)
          } else {
            ForEach(completeTodos) { todo in
              Button {
                self.toggleComplete(todo.id)
              } label: {
                Text(todo.wrappedTitle)
              }
            }
          }
        }

      } else {
        ForEach(sortedTodos) { todo in
          Button {
            self.toggleComplete(todo.id)
          } label: {
            Text(todo.wrappedTitle)
              .foregroundColor(todo.isComplete ? .secondary : .primary)
              .strikethrough(todo.isComplete ? true : false)
          }
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
    } else if completeHandling == .delete {
      title = "To-Day: \(totalTodos) remaining"
      if completedTodos == 0 {
        imageName = "checklist.unchecked"
      } else {
        imageName = "checklist"
      }
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
    let maxOrder = todos.reduce(0) { partialResult, todo in
      max(partialResult, todo.order)
    }
    let newTodo = Todo(order: maxOrder + 1, title: title)
    todos.append(newTodo)
  }

  func deleteTodo(_ todo: Todo) {
    todos.removeAll {
      $0.id == todo.id
    }
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
    }
  }

  func toggleComplete(_ id: UUID) {
    let todoIndex = todos.firstIndex {
      $0.id == id
    }
    if let todoIndex {
      if completeHandling == .delete {
        todos.remove(at: todoIndex)
      } else {
        todos[todoIndex].isComplete.toggle()
      }
    }
  }

  func markAll(complete: Bool) {
    for index in 0 ..< todos.count {
      todos[index].isComplete = complete
    }
  }

  func checkForDeleteCompleted() {
    guard completeHandling == .delete else {
      return
    }
    todos.removeAll { $0.isComplete }
  }
}
