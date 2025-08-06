import SwiftUI

struct WorkoutRowView: View {
    @ObservedObject var vm: WorkoutRowViewModel

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

            // Previous
            Text("\(vm.previousKg) x \(vm.previousReps)")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(width: 70, alignment: .leading)
                .opacity(0.5)

            // Kg
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(0.2))
                Text("\( (vm.kg == nil) ? "" : "\(vm.kg ?? 0)") ")
                    .onTapGesture {
                        vm.startTyping(.kg)
                    }
                    .font(.body)
            }
            .frame(width: 50, height: 40)
            .padding(.horizontal, 5)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            // Reps
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(0.2))
                Text("\( (vm.reps == nil) ? "" : "\(vm.reps ?? 0)") ")
                    .onTapGesture {
                        vm.startTyping(.reps)
                    }
                    .font(.body)
            }
            .frame(width: 50, height: 40)
            .padding(.horizontal, 5)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            // Completed
            Toggle("", isOn: $vm.isCompleted)
                .frame(width: 50, height: 40)
            
            // Space
            Spacer()
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    WorkoutRowView(vm: WorkoutRowViewModel(id: 1, previousKg: 15, previousReps: 10) { id, _ in print(id)})
}
