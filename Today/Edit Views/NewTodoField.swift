//
//  NewTodoField.swift
//  To-Day
//
//  Created by Sarah Reichelt on 16/2/2023.
//

import SwiftUI

struct NewTodoField: View {
  @EnvironmentObject var appState: AppState
  @State private var newTitle = ""
  @FocusState var editFieldHasFocus: Bool

  var body: some View {
    TextField("Enter new todo and press Return.", text: $newTitle)
      .focused($editFieldHasFocus)
      .frame(maxWidth: .infinity)
      .padding(.horizontal)

      .onSubmit {
        // only works with Return
        if !newTitle.isEmpty {
          appState.createNewTodo(title: newTitle)
          newTitle = ""
          editFieldHasFocus = true
        }
      }
      .onAppear {
        editFieldHasFocus = true
      }
      .onDisappear {
        appState.todoBeingEdited = nil
      }
      .onChange(of: appState.todoBeingEdited) { newValue in
        if newValue == nil {
          editFieldHasFocus = true
        }
      }
  }
}

struct NewTodoField_Previews: PreviewProvider {
  static var previews: some View {
    NewTodoField()
      .environmentObject(AppState())
      .frame(width: 350)
  }
}
