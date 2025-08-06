import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Grid Headings
            HStack(spacing: 14) {
                Text("Set")
                    .font(.subheadline)
                    .frame(width: 40, alignment: .center)
                Text("Previous")
                    .font(.subheadline)
                    .frame(width: 70, alignment: .leading)
                Text("Kg")
                    .font(.subheadline)
                    .frame(width: 60, alignment: .center)
                Text("Reps")
                    .font(.subheadline)
                    .frame(width: 60, alignment: .center)
                Spacer(minLength: 50)
            }
            // Set Rows
            ForEach($viewModel.sets) { $set in
                WorkoutRowView(vm: set)
            }
        }
    }
}

#Preview {
    WorkoutView(viewModel: WorkoutViewModel())
}
