import SwiftUI

struct ChallengesListView: View {
    @State private var challenges = sampleChallenges
    @State private var lunchMateChallenges = sampleLunchMateChallenges
    @State private var showOngoingChallenges = false
    @State private var selectedSection: ChallengeSection = .spotsHosted

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 1.0, green: 0.776, blue: 0.0), Color(red: 0.835, green: 0.4, blue: 0.086)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    LevelBar(level: 1, progress: 0.5)

                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showOngoingChallenges.toggle()
                            }
                        }) {
                            ZStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.blue)
                                if challenges.filter({ $0.isJoined }).count > 0 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 10, height: 10)
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                        .padding()
                    }

                    HStack {
                        Button(action: {
                            selectedSection = .lunchMate
                        }) {
                            Text("LunchMate")
                                .padding()
                                .background(selectedSection == .lunchMate ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedSection = .spotsHosted
                        }) {
                            Text("Spots-Hosted")
                                .padding()
                                .background(selectedSection == .spotsHosted ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()

                    ScrollView {
                        VStack {
                            if selectedSection == .lunchMate {
                                ForEach($lunchMateChallenges) { $challenge in
                                    NavigationLink(destination: LunchMateDetailView(challenge: $challenge)) {
                                        ChallengeCardView(challenge: challenge)
                                    }
                                }
                            } else {
                                ForEach($challenges) { $challenge in
                                    NavigationLink(destination: ChallengeDetailView(challenge: $challenge)) {
                                        ChallengeCardView(challenge: challenge)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Food Challenges")
                }
            }
            .overlay(
                VStack {
                    if showOngoingChallenges {
                        OngoingChallengesPopup(challenges: challenges, isVisible: $showOngoingChallenges)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: showOngoingChallenges)
                    }
                }
                .animation(.easeInOut)
                , alignment: .top)
        }
    }
}

enum ChallengeSection {
    case lunchMate
    case spotsHosted
}

struct ChallengesListView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListView()
    }
}
