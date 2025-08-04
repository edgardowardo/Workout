import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center, spacing: 20) {
                // Section Header
                HStack {
                    Text("Bench Press (Dumbbell)")
                        .font(.title3)
                        .padding(.top, 20)
                        .padding(.leading, 10)
                    Spacer()
                }
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
                        .frame(width: 68, alignment: .center)
                    Text("Reps")
                        .font(.subheadline)
                        .frame(width: 68, alignment: .center)
                    Spacer(minLength: 10)
                }
                // Set Rows
                ForEach($viewModel.sets) { $set in
                    WorkoutRowView(set: set)
                }
            }
            .padding([.horizontal, .bottom], 24)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
                    .padding(.horizontal, 16)
            )

            Spacer()
        }
        .padding(.top, 80)
    }
}


#Preview {
    WorkoutView(viewModel: WorkoutViewModel())
}
