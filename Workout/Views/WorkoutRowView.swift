import SwiftUI

struct WorkoutRowView: View {
    @ObservedObject var set: WorkoutRowViewModel
    
    var body: some View {
        HStack(spacing: 14) {
            // Set id
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(0.2))
                Text("\(set.id)")
                    .font(.body)
            }
            .frame(width: 40, height: 40)
            // Previous
            Text("\(set.previousKg) x \(set.previousReps)")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(width: 70, alignment: .leading)
                .opacity(0.5)
            // Kg
            TextField("", value: $set.kg, format: .number)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 40)
                .padding(.horizontal, 5)
                .background(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            // Reps
            TextField("", value: $set.reps, format: .number)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 40)
                .padding(.horizontal, 5)
                .background(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            // Completed
            Toggle("", isOn: $set.isCompleted)
                .frame(width: 50, height: 40)
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    WorkoutRowView(set: WorkoutRowViewModel(id: 1, previousKg: 15, previousReps: 10))
}
