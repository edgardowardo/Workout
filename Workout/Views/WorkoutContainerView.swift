import SwiftUI

struct WorkoutContainerView: View {
    @StateObject private var viewModel = WorkoutViewModel()

    var body: some View {
        ZStack {

            WorkoutBackgroundView()
            
            List {
                Section("Bench Press (Dumbbell)") {
                    WorkoutView(viewModel: viewModel)
                }
                .foregroundStyle(.primary)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    WorkoutContainerView()
}
