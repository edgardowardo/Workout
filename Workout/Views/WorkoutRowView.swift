import SwiftUI

struct WorkoutRowView: View {
    @ObservedObject var set: WorkoutRowViewModel
    
    var body: some View {
        HStack(spacing: 14) {
            // Set id
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(white: 0.97))
                Text("\(set.id)")
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .frame(width: 40, height: 40)
            // Previous
            Text("\(set.previousKg, specifier: "%.0f") x \(set.previousReps, specifier: "%.0f")")
                .font(.body)
                .foregroundColor(.gray)
                .frame(width: 70, alignment: .leading)
                .opacity(0.5)
            // Kg
            TextField("", value: $set.kg, format: .number.precision(.fractionLength(2)))
                .keyboardType(.decimalPad)
                .frame(width: 50, height: 40)
                .padding(.horizontal, 8)
                .background(Color(white: 0.96))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            // Reps
            TextField("", value: $set.reps, format: .number.precision(.fractionLength(2)))
                .keyboardType(.decimalPad)
                .frame(width: 50, height: 40)
                .padding(.horizontal, 8)
                .background(Color(white: 0.96))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            // Completed
            Toggle("", isOn: $set.isCompleted)
                .glassEffect()
        }
    }
}

#Preview {
    WorkoutRowView(set: WorkoutRowViewModel(id: 1, previousKg: 15, previousReps: 10))
}
