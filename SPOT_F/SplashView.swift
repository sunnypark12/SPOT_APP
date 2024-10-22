//
//  SplashView.swift
//  SPOT_F
//
//  Created by 선호 on 7/1/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted: Bool = false
    
    @State private var showText = false
    @State private var bounceAnimation = false
    @State private var hideSmiley = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 1.0, green: 0.776, blue: 0.0), location: 0.3),
                        .init(color: Color(red: 0.835, green: 0.4, blue: 0.086), location: 0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if showText {
                        Text("SPOT")
                            .font(.custom("TitanOne", size: 50))
                            .foregroundColor(.white)
                            .padding()
                            .transition(.opacity)
                    }
                }

                GeometryReader { geometry in
                    if !hideSmiley {
                        Image("Smiley_Face")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .position(x: bounceAnimation ? geometry.size.width / 2 : geometry.size.width, y: bounceAnimation ? geometry.size.height / 2 : -80)
                            .animation(
                                Animation.interpolatingSpring(stiffness: 50, damping: 5)
                                    .repeatCount(1, autoreverses: false)
                            )
                    }
                }
            }
            .onAppear {
                // Start the bounce animation
                bounceAnimation = true

                // Show text and hide smiley face after the last bounce
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut) {
                        showText = true
                        hideSmiley = true
                    }
                }
                
                // Simulate a delay for the splash screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.isActive = true
                }
            }
            .navigationDestination(isPresented: $isActive) {
                if isOnboardingCompleted {
                    HomeContainerView()
                } else {
                    BoardingView()
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
