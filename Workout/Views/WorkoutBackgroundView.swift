import SwiftUI

struct WorkoutBackgroundView: View {
    var body: some View {
        GeometryReader { geo in
            Image(.background)
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
