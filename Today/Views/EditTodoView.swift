//
//  EditTodoView.swift
//  To-Day
//
//  Created by Sarah Reichelt on 16/2/2023.
//

import SwiftUI

struct EditTodoView: View {
  @ObservedObject var appState: AppState
  @Binding var todo: Todo
  @FocusState var editingTodo: Bool

  var body: some View {
    HStack {
      TextField("", text: $todo.title)
        .focused($editingTodo)

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

        Toggle("", isOn: $todo.isComplete)
          .labelsHidden()
          .padding(.trailing, 6)
          .toggleStyle(.switch)
          .tint(.green)
      }
      .buttonStyle(.plain)
    }
    .onChange(of: editingTodo) { newValue in    
      if newValue {
        appState.todoBeingEdited = todo
      } else {
        if appState.todoBeingEdited == todo {
          appState.todoBeingEdited = nil
        }
      }
    }
  }
}

struct EditTodoView_Previews: PreviewProvider {
  static var previews: some View {
    EditTodoView(appState: AppState(), todo: .constant(Todo.sampleToDos[0]))
      .frame(width: 350)
  }
}
