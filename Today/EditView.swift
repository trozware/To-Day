//
//  EditView.swift
//  Today
//
//  Created by Sarah Reichelt on 18/1/2023.
//

//  TODO: keyboard shortcuts - requires list items to be selectable somehow

import SwiftUI

struct EditView: View {
  @ObservedObject var appState: AppState
  @State private var newTitle = ""
  @FocusState var editFieldHasFocus: Bool

  var body: some View {
    List() {
      ForEach($appState.todos) { $todo in
        HStack {
          TextField("", text: $todo.title)

          Spacer()

          HStack(spacing: 20) {
            Button {
              appState.move(todo, direction: "up")
            } label: {
              Image(systemName: "arrow.up")
            }
            .disabled(todo.id == 1)

            Button {
              appState.move(todo, direction: "down")
            } label: {
              Image(systemName: "arrow.down")
            }
            .disabled(todo.id == appState.todos.count)

            Button {
              appState.deleteTodo(todo)
            } label: {
              Image(systemName: "trash")
                .foregroundColor(.red)
            }
          }
          .buttonStyle(.plain)
        }
      }

      TextField("Enter new todo and press Return.", text: $newTitle)
        .focused($editFieldHasFocus)
        .onSubmit() {
          // only works with Return
          if !newTitle.isEmpty {
            appState.createNewTodo(title: newTitle)
            newTitle = ""
            editFieldHasFocus = true
          }
        }

      Spacer()
    }
    .listStyle(.inset(alternatesRowBackgrounds: true))
    .frame(minWidth: 350)
    .environment(\.defaultMinListRowHeight, 30)
    .onAppear {
      editFieldHasFocus = true
    }
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView(appState: AppState())
      .frame(width: 350)
  }
}
