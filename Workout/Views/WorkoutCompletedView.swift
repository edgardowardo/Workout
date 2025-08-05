import SwiftUI

struct WorkoutCompletedView: View {
    let viewModel: WorkoutViewModel
    var body: some View {
        NavigationView {
            List {
                Section("Bench Press (Dumbbell)") {
                    ForEach(viewModel.sets) { set in
                        WorkoutRowCompletedView(vm: WorkoutRowCompletedViewModel(set))
                    }
                    
                }
                .foregroundStyle(.primary)
            }
            .navigationTitle("Test Complete")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Text(viewModel.completedDateDisplay)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 5)
                }
            }
        }
    }
}

struct WorkoutRowCompletedView: View {
    let vm: WorkoutRowCompletedViewModel
    var body: some View {
        HStack(spacing: 14) {
            // Set id
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(0.2))
                Text("\(vm.id)")
                    .font(.body)
            }
            .frame(width: 40, height: 40)
            // Kg x Reps
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(0.2))
                Text(vm.kgAndRep)
                    .font(.body)
            }
            .frame(width: 100, height: 40)
        }
    }
}

