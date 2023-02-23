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
  @Binding var isEnteringNew: Bool

  var body: some View {
    TextField("", text: $newTitle)
      .focused($editFieldHasFocus)
      .labelsHidden()
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
      .onChange(of: editFieldHasFocus) { newValue in
        isEnteringNew = newValue
      }
      .onChange(of: isEnteringNew) { _ in
        editFieldHasFocus = isEnteringNew
      }
  }
}

struct NewTodoField_Previews: PreviewProvider {
  static var previews: some View {
    NewTodoField(isEnteringNew: .constant(true))
      .environmentObject(AppState())
      .frame(width: 350)
  }
}
