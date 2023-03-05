//
//  EditView.swift
//  Today
//
//  Created by Sarah Reichelt on 18/1/2023.
//

import SwiftUI

struct EditView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      Form {
        ForEach($appState.todos) { $todo in
          EditTodoView(todo: $todo)
        }

        VStack(alignment: .leading) {
          Text("Enter new todo and press Return:")
          NewTodoField()
        }
      }
      .formStyle(.grouped)
      .textFieldStyle(.squareBorder)

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

  }

  func deleteAll() {
    appState.deleteAll()
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView()
      .environmentObject(AppState())
      .frame(width: 350)
  }
}
