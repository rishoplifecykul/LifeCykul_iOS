//
//  SplashScreen.swift
//  LifeCykul
//
//  Created by Rishop Babu on 21/03/25.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var isActive: Bool = false
    @State private var opacity: Double = 0.3
    
    var body: some View {
        if isActive {
            LoginView()
        } else {
            VStack {
                Image("SplashImage")
                    .resizable()
                    .scaledToFit()
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) {
                            self.opacity = 1.0
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
