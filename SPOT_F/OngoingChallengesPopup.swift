//
//  OngoingChallengesPopup.swift
//  SPOT_F
//
//  Created by 선호 on 7/3/24.
//
import SwiftUI

struct OngoingChallengesPopup: View {
    let challenges: [Challenge]
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            HStack {
                Text("Ongoing Challenges")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    withAnimation {
                        isVisible = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()

            ScrollView {
                VStack {
                    ForEach(challenges) { challenge in
                        HStack {
                            Text(challenge.name)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Spacer()
                            Text(challenge.deadline)
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        Divider().background(Color.white)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(12)
        .padding()
    }
}

struct OngoingChallengesPopup_Previews: PreviewProvider {
    static var previews: some View {
        OngoingChallengesPopup(challenges: sampleChallenges, isVisible: .constant(true))
    }
}
