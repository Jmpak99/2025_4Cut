//
//  fourcutApp.swift
//  fourcut
//
//  Created by 박종민 on 11/21/24.
//

import SwiftUI
import Firebase

@main
struct fourcutApp: App {
    // 파베 초기화
    init() {
         FirebaseApp.configure()
     }
    
    var body: some Scene {
        // 앱의 주요 UI를 포함하는 Scene
        WindowGroup {
            ContentView() // 앱 실행 시 표시할 초기 View
        }
    }
}

