import SwiftUI
import CoreLocation

struct ProfileSettingsView: View {
    @State private var isExpanded = false
    @State private var selectedTab: Int = 4
    @StateObject private var locationManager = LocationManager()
//    @State private var restaurants: [Restaurant] = [
//        Restaurant(name: "Restaurant 1", iconName: "crown.fill", location: CLLocation(latitude: 37.7749, longitude: -122.4194)),
//        Restaurant(name: "Restaurant 2", iconName: "heart.fill", location: CLLocation(latitude: 37.7849, longitude: -122.4094)),
//        Restaurant(name: "Restaurant 3", iconName: "star.fill", location: CLLocation(latitude: 37.7949, longitude: -122.4294))
//    ]
    var body: some View {
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
                ProfileHeader()
                    .padding(.top, 50)
                
                VStack(alignment: .center, spacing: 16) {
                    SettingItemView(label: "Email")
                    SettingItemView(label: "Change password")
                    SettingItemView(label: "About Spot")
                    SettingItemView(label: "Terms & privacy")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 100)

                Spacer()

                NavigationLink(destination: SplashView()) {
                    HStack(spacing: 4) {
                        ZStack {
                            ZStack { }
                            .frame(width: 15.86, height: 15.42)
                            .offset(x: 0.24, y: 0.02)
                        }
                        .frame(width: 20, height: 20)
                        Text("Log out")
                            .font(Font.custom("Chenla", size: 14))
                            .lineSpacing(21)
                            .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    }
                    .padding(EdgeInsets(top: 7, leading: 14, bottom: 8, trailing: 14))
                    .background(Color.white)
                    .cornerRadius(30)
                }
                .padding(.bottom,200)
            }
            
            // Bottom navigation bar
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    if isExpanded {
                        NavigationLink(destination: MapView()) {
                            CircleBut(icon: "map.fill")
                        }
                        .offset(y: -100)
                        
                        NavigationLink(destination: ChallengesListView()) {
                            CircleBut(icon: "star.fill")
                        }
                        .offset(x: -80, y: -60)
                        
                        NavigationLink(destination: ProfileView()) {
                            CircleBut(icon: "person.fill")
                        }
                        .offset(x: 80, y: -60)
                    }
                    
                    // Smiley face button
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Image("Smiley_Face")
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct SettingItemView: View {
    var label: String
    
    var body: some View {
        HStack(spacing: 20) {
            Text(label)
                .font(.custom("TitanOne", size: 18))
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 6))
        .frame(width: 220, height: 40)
        .background(Color(red: 1, green: 1, blue: 1).opacity(0.20))
        .cornerRadius(40)
    }
}

struct ProfileHeader: View {
    var body: some View {
        VStack {
            HStack(alignment:.center) {
                ZStack {
                    Ellipse()
                        .foregroundColor(.clear)
                        .frame(width: 60, height: 60)
                        .background(
                            AsyncImage(url: URL(string: "https://via.placeholder.com/60x60"))
                        )
                        .offset(x: 20, y: 0)
                }
                .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bruno Pham")
                        .font(Font.custom("Chenla", size: 16))
                        .lineSpacing(19.20)
                        .foregroundColor(.white)
                    Text("thanhphamdhbk@gmail.com")
                        .font(Font.custom("Chenla", size: 12))
                        .lineSpacing(18)
                        .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75))
                }
                .frame(maxWidth: .infinity)
                Spacer()
                NavigationLink(destination: EditProfileView()) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment:.center)
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(20)
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
