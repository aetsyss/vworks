//
//  ResearchRootApp.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 10/28/24.
//

import SwiftUI
import Profile

@main
struct ResearchRootApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ResearchRootView(
                        viewModel: ResearchRootViewModel()
                    )
                }
                .tabItem {
                    Label("Research", systemImage: "house")
                }
                
                NavigationView {
                    ProfileView()
                        .environment(\.profileViewStyle, Style(titleFont: .largeTitle.bold()))
                        .navigationTitle("Profile")
                }
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            }
        }
    }
}

struct Style: ProfileViewStyle {
    let titleFont: Font
}
