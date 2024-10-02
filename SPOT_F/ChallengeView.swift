//
//  ChallengeView.swift
//  SPOT_F
//
//  Created by 선호 on 7/1/24.
//

import SwiftUI

struct ChallengeView: View {
    let challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(challenge.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)

            Text(challenge.name)
                .font(.title)
                .bold()

            HStack {
                Text("Deadline:")
                    .font(.headline)
                Spacer()
                Text(challenge.deadline)
                    .foregroundColor(.gray)
            }

            HStack {
                Text("Prize:")
                    .font(.headline)
                Spacer()
                Text(challenge.prize)
                    .foregroundColor(.gray)
            }

            Text(challenge.description)
                .font(.body)
                .foregroundColor(.secondary)

            Button(action: {
                // Join challenge action
            }) {
                Text("Join Challenge")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challenge: sampleChallenges[0])
    }
}

