//
//  CryptoCourseApp.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 08.06.2022.
//

import SwiftUI

@main
struct CryptoCourseApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
