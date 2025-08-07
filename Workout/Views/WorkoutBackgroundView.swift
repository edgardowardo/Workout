import SwiftUI

struct WorkoutBackgroundView: View {
    var body: some View {
        GeometryReader { geo in
            Image(.bg)
                .resizable()
                .scaledToFill()
                .clipped()
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    WorkoutBackgroundView()
}
