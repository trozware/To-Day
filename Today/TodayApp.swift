//
//  TodayApp.swift
//  Today
//
//  Created by Sarah Reichelt on 16/1/2023.
//

import SwiftUI
import ServiceManagement

@main
struct TodayApp: App {
  @State private var dataStore = DataStore()
  @State private var todos: [Todo] = DataStore().loadTodos()
  @State private var launchOnLogin = SMAppService.mainApp.status == .enabled

  @AppStorage("sortCompletedToEnd") var sortCompletedToEnd = true

  @Environment(\.openWindow) private var openWindow

  var body: some Scene {
    MenuBarExtra {
      todoButtons

      Divider()

      Button("Mark All Complete") {
        for index in 0 ..< todos.count {
          todos[index].isComplete = true
        }
        dataStore.saveTodos(todos: todos)
      }
      .disabled(allComplete)

      Button("Mark All Incomplete") {
        for index in 0 ..< todos.count {
          todos[index].isComplete = false
        }
        dataStore.saveTodos(todos: todos)
      }
      .disabled(allIncomplete)

      Toggle("Completed at End", isOn: $sortCompletedToEnd)

      Divider()

      Button("Edit Todos…") {
        openWindow(id: "edit_todos")
        NSApp.activate(ignoringOtherApps: true)
      }

      Toggle("Launch on Login", isOn: $launchOnLogin)

      Divider()

      Button("Quit To-Day") {
        NSApp.terminate(nil)
      }
    } label: {
      menuTitle
    }
    .onChange(of: launchOnLogin) { _ in
      toggleLaunchOnLogin()
    }

    Window("Edit Todos", id: "edit_todos") {
      EditView(todos: $todos)
    }
    .defaultSize(width: 350, height: 400)
  }

}

// MARK: - Computed Properties

extension TodayApp {
  var sortedTodos: [Todo] {
    if sortCompletedToEnd {
      return todos.sorted(using: KeyPathComparator(\.sortProperty))
    } else {
      return todos.sorted(using: KeyPathComparator(\.id))
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
        toggleComplete(todo.id)
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

    if completedTodos == totalTodos {
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

extension TodayApp {

  func toggleComplete(_ id: Int) {
    let todoIndex = todos.firstIndex {
      $0.id == id
    }
    if let todoIndex {
      todos[todoIndex].isComplete.toggle()
    }

    DataStore().saveTodos(todos: todos)
  }

  func toggleLaunchOnLogin() {
    do {
      if SMAppService.mainApp.status == .enabled {
        try SMAppService.mainApp.unregister()
      } else {
        try SMAppService.mainApp.register()
      }
    } catch {
      print(error)
    }
  }
}

