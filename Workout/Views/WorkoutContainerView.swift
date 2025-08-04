import SwiftUI

struct WorkoutContainerView: View {
    @StateObject private var viewModel = WorkoutViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            
            WorkoutBackgroundView()
            
            WorkoutView(viewModel: viewModel)
            
            PillView(viewModel: viewModel)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    WorkoutContainerView()
}
