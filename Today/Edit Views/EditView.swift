//
//  EditView.swift
//  Today
//
//  Created by Sarah Reichelt on 18/1/2023.
//

import SwiftUI

struct EditView: View {
  @EnvironmentObject var appState: AppState
  @State private var isEnteringNew = false

  var body: some View {
    VStack {
      Form {
        ForEach($appState.todos) { $todo in
          EditTodoView(todo: $todo)
        }

        VStack(alignment: .leading) {
          Text("Enter new todo and press Return:")
          NewTodoField(isEnteringNew: $isEnteringNew)
        }
      }
      .formStyle(.grouped)
      .textFieldStyle(.squareBorder)
      .listStyle(.sidebar)
      .environment(\.defaultMinListRowHeight, 32)

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
      if newValue {
        appState.todoBeingEdited = nil
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
    isEnteringNew = true

    appState.deleteAll()
  }

  func deleteSelected(_ todo: Todo) {
    appState.todoBeingEdited = nil
    isEnteringNew = true

    // if this is done immediately, deleting the last todo crashes the app
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      appState.deleteTodo(todo)
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
