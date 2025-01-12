//
//  SwiftUIView.swift
//  Profile
//
//  Created by Aleksei Tsyss on 11/24/24.
//

import SwiftUI

public protocol ProfileViewStyle: Sendable {
    var titleFont: Font { get }
}

public struct ProfileView: View {
    @Environment(\.profileViewStyle) var style
    
    public init() { }
    
    public var body: some View {
        Text("Profile from package")
            .font(style.titleFont)
    }
}

struct Style: ProfileViewStyle {
    let titleFont: Font
}

struct ProfileViewStyleKey: EnvironmentKey {
    static let defaultValue: ProfileViewStyle = Style(titleFont: .title)
}

extension EnvironmentValues {
    public var profileViewStyle: ProfileViewStyle {
        get { self[ProfileViewStyleKey.self] }
        set { self[ProfileViewStyleKey.self] = newValue }
    }
}

#if DEBUG

#Preview {
    NavigationView {
        ProfileView()
            .environment(\.profileViewStyle, Style(titleFont: .largeTitle))
            .navigationTitle("Profile")
    }
}

#endif
