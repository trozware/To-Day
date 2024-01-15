//
//  AboutView.swift
//  To-Day
//
//  Created by Sarah Reichelt on 18/1/2023.
//

import SwiftUI

// swiftlint: disable line_length

struct AboutView: View {
  var body: some View {
    VStack(spacing: 20) {
      Image("icon")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 150)

      Text("I wanted a very simple menubar app that showed a list of items that I could check off over the day. Nothing long term, just day-by-day.")

      Text("Every app I found had a terrific list of features, most of which I didn't want, so I wrote my own.")

      Text("Use the **Edit Todos…** menu item to add, delete and edit your todos. Select them in the menu to mark them as complete or incomplete.")

      Text("There are only two settings: **Show Completed** lets you choose how to display, hide or delete the completed todos and **Launch on Login** sets whether you want the app to start automatically when you log in.")

      Text("Translation and VoiceOver help by [Sebastian Dellit](www.blindzeln.org).")

      VStack(spacing: 3) {
        Text("This app is free, but if you'd like to support it, please:")
        Button {
          buyCoffee()
        } label: {
          Image("kofi")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 50)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Buy me a coffee")
      }

      VStack(spacing: 3) {
        Text("If you'd like to contact me, I'm [@troz@mastodon.social](https://mastodon.social/@troz) on Mastodon:")
        Button {
          mastodon()
        } label: {
          Image("mastodon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Find me on Mastodon")

        Spacer()

        Text(versionAndBuild())
          .font(.headline)
          .padding(.bottom, 0)
      }

    }
    .fixedSize(horizontal: false, vertical: true)
    .font(.title3)
    .multilineTextAlignment(.center)
    .frame(width: 500)
    .padding()
  }

  func buyCoffee() {
    let address = "https://ko-fi.com/H2H3BU7SI"
    guard let url = URL(string: address) else {
      fatalError("Bad Kofi URL!")
    }
    NSWorkspace.shared.open(url)
  }

  func mastodon() {
    let address = "https://mastodon.social/@troz"
    guard let url = URL(string: address) else {
      fatalError("Bad Mastodon URL!")
    }
    NSWorkspace.shared.open(url)
  }

  func versionAndBuild() -> String {
    if
      let bundleInfo = Bundle.main.infoDictionary,
      let version = bundleInfo["CFBundleShortVersionString"] as?
        String,
      let build = bundleInfo["CFBundleVersion"] as? String {
      return "To-Day: v\(version) (\(build))"
    }
    return " "
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView()
  }
}

// swiftlint: enable line_length
