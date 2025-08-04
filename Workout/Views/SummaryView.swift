import SwiftUI

struct SummaryView: View {
    let sets: [WorkoutRowViewModel]

    var body: some View {
        VStack(spacing: 12) {
            Text("Test Complete").font(.headline)
            ForEach(sets) { set in
                Text("Set \(set.id): \(set.kg ?? 0)kg x \(set.reps ?? 0)")
            }
        }
    }
}
