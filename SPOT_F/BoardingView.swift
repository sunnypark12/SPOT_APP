//
//  BoardingView.swift
//  SPOT_F
//
//  Created by 선호 on 7/1/24.
//

import SwiftUI

struct BoardingView: View {
    @State private var isActive = false
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted: Bool = false
    
    @State private var showSpeechBubble = false
    @State private var isBlinking = false
    @State private var navigateToHome = false

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
                    Spacer()

                    // Speech bubble
                    if showSpeechBubble {
                        Text("Hi, Nice to meet you!\nI am SPOT, your personal guide!")
                            .font(.custom("TitanOne", size: 18))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                            .transition(.opacity)
                    }

                    // Smiley face with navigation link
                    Image("Smiley_Face")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .padding()
                        .onTapGesture {
                            navigateToHome = true
                        }
                    
                    // Blinking "Click on Me" text
                    if !navigateToHome {
                        Text("Click on Me!")
                            .font(.custom("TitanOne", size: 16))
                            .foregroundColor(isBlinking ? .white : .clear)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                                    isBlinking.toggle()
                                }
                            }
                    }

                    Spacer()
                }
            }
            .onAppear {
                // Show speech bubble after 1 sec
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        showSpeechBubble = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                OverView()
            }
        }
    }
}

struct BoardingView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingView()
    }
}
