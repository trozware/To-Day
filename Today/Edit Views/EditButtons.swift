//
//  EditButtons.swift
//  To-Day
//
//  Created by Sarah Reichelt on 5/3/2023.
//

import SwiftUI

struct EditButtons: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    HStack {
      Button(role: .destructive) {
        appState.deleteAll()
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
}

struct EditButtons_Previews: PreviewProvider {
  static var previews: some View {
    EditButtons()
      .environmentObject(AppState())
  }
}
