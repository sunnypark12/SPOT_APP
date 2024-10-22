//
//  OverView.swift
//  SPOT_F
//
//  Created by 선호 on 7/1/24.
//


import SwiftUI

struct OverView: View {
    @State private var isExpanded = false
    @State private var currentStep = 0
    @State private var blurAmount: CGFloat = 0.0
    @State private var smileyOpacity: Double = 1.0
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 1.0, green: 0.776, blue: 0.0), Color(red: 0.835, green: 0.4, blue: 0.086)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        // Four circles
                        if isExpanded {
                            CircleButton(icon: "house.fill", text: "View Spotted Food", action: {}, blur: currentStep != 1 ? blurAmount : 0, scale: currentStep == 1 ? 1.5 : 1)
                                .offset(y: currentStep == 1 ? 0 : -125)
                            CircleButton(icon: "map.fill", text: "View SPOTs Near You", action: {}, blur: currentStep != 2 ? blurAmount : 0, scale: currentStep == 2 ? 1.5 : 1)
                                .offset(x: currentStep == 2 ? 0 : -125)
                            CircleButton(icon: "star.fill", text: "Discover SPOT Challenges", action: {}, blur: currentStep != 3 ? blurAmount : 0, scale: currentStep == 3 ? 1.5 : 1)
                                .offset(x: currentStep == 3 ? 0 : 125)
                            CircleButton(icon: "person.fill", text: "View Your SPOT Profile", action: {}, blur: currentStep != 4 ? blurAmount : 0, scale: currentStep == 4 ? 1.5 : 1)
                                .offset(y: currentStep == 4 ? 0 : 125)
                        }
                        
                        // Smiley face button
                        Button(action: {
                            withAnimation {
                                isExpanded = true
                                startAnimationSequence()
                            }
                        }) {
                            Image("Smiley_Face")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .opacity(smileyOpacity)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeContainerView()
            }
        }
    }
    
    private func startAnimationSequence() {
        let totalSteps = 4
        let animationDuration: Double = 1.2
        
        withAnimation {
            smileyOpacity = 0.0
        }
        
        for step in 1...totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * animationDuration) {
                withAnimation {
                    currentStep = step
                    blurAmount = 40.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * animationDuration) {
                    withAnimation {
                        blurAmount = 20.0
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalSteps + 1) * animationDuration) {
            withAnimation {
                isExpanded = true
                currentStep = 0
                navigateToHome = true
            }
        }
    }
}

struct CircleButton: View {
    var icon: String
    var text: String
    var action: () -> Void
    var blur: CGFloat
    var scale: CGFloat

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 130, height: 130)
                    .blur(radius: blur)
                    .scaleEffect(scale)
                VStack {
                    Image(systemName: icon)
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .blur(radius: blur)
                        .scaleEffect(scale)
                        .padding(.bottom, 10)
                    Text(text)
                        .font(.custom("TitanOne", size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .blur(radius: blur)
                        .scaleEffect(scale)
                        .padding(.bottom, 4)
                }
            }
            .frame(width: 130, height: 130)
        }
        
    }
}
struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView()
    }
}
