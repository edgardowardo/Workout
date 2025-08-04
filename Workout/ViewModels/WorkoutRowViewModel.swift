import Combine

class WorkoutRowViewModel: ObservableObject, Identifiable {
    let id: Int
    let previousKg: Double
    let previousReps: Double
    @Published var kg: Double?
    @Published var reps: Double?
    @Published var isCompleted: Bool
    
    init(id: Int, previousKg: Double, previousReps: Double, kg: Double? = nil, reps: Double? = nil, isCompleted: Bool = false) {
        self.id = id
        self.previousKg = previousKg
        self.previousReps = previousReps
        self.kg = kg
        self.reps = reps
        self.isCompleted = isCompleted
    }
}
