//
//  EditView.swift
//  Today
//
//  Created by Sarah Reichelt on 18/1/2023.
//

import SwiftUI

// TODO: Not sure about text edit styles in list

// CONSIDER: how would the edit view look embedded in a Form?

struct EditView: View {
  @EnvironmentObject var appState: AppState
  @State private var isEnteringNew = false
  @State private var justTabbedToFirst = false

  var body: some View {
    VStack {
      List {
        ForEach($appState.todos) { $todo in
          EditTodoView(todo: $todo)
        }
      }
      .textFieldStyle(.squareBorder)
      .listStyle(.sidebar)
      .environment(\.defaultMinListRowHeight, 32)

      Spacer()

      NewTodoField(isEnteringNew: $isEnteringNew)

      helpText

      HStack {
        Button(role: .destructive) {
          deleteAll()
        } label: {
          Text("Delete All")
            .foregroundColor(.red)
            .opacity(appState.todos.isEmpty ? 0.5 : 1)
        }
        .disabled(appState.todos.isEmpty)

        Spacer()

        Button("Mark All Incomplete") {
          appState.markAll(complete: false)
        }
        .disabled(appState.allIncomplete)
      }
      .padding([.horizontal, .bottom], 12)
    }
    .frame(minWidth: 350, minHeight: 300)
    .onAppear(perform: monitorKeystrokes)
    .onDisappear {
      appState.todoBeingEdited = nil
    }
    .onChange(of: isEnteringNew) { newValue in
      if newValue == false {
        tabOutOfNew()
      }
    }
  }

  var helpText: Text {
    let commandImg = Image(systemName: "command")
    let arrowUpImg = Image(systemName: "arrow.up")
    let arrowDownImg = Image(systemName: "arrow.down")

    if appState.todoBeingEdited != nil {
      let editMsg = Text("Use \(commandImg) \(arrowUpImg) or ") +
                         Text("\(commandImg) \(arrowDownImg) to move the todo, ") +
                         Text("\(commandImg) D to delete.")
      return editMsg
    } else {
      return Text("Type and press Return, or click a todo to edit.")
    }
  }

  func monitorKeystrokes() {
    NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
      guard let todo = appState.todoBeingEdited else {
        return event
      }

      if event.keyCode == KeyCodes.tabKey {
        if justTabbedToFirst {
          justTabbedToFirst = false
        } else if let nextTodo = appState.nextTodo(after: todo) {
          appState.todoBeingEdited = nextTodo
        } else {
          isEnteringNew = true
        }
        return event
      }

      if event.modifierFlags.contains(.command) {
        let keyCode = event.keyCode
        switch keyCode {
        case KeyCodes.upArrow:
          appState.move(todo, direction: .up)
        case KeyCodes.downArrow:
          appState.move(todo, direction: .down)
        case KeyCodes.dKey:
          deleteSelected(todo)
        default:
          // print("command: \(keyCode)")
          break
        }
      }
      return event
    }
  }

  func deleteAll() {
    appState.todoBeingEdited = nil
    justTabbedToFirst = false
    isEnteringNew = true

    appState.deleteAll()
  }

  func deleteSelected(_ todo: Todo) {
    appState.todoBeingEdited = nil
    justTabbedToFirst = false
    isEnteringNew = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      appState.deleteTodo(todo)
    }
  }

  func tabOutOfNew() {
    justTabbedToFirst = true
    if appState.todoBeingEdited == nil {
      appState.todoBeingEdited = appState.todos.first
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      justTabbedToFirst = false
    }
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView()
      .environmentObject(AppState())
      .frame(width: 350)
  }
}
