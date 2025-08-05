import Combine

class WorkoutRowViewModel: ObservableObject, Identifiable {
    let id: Int
    let previousKg: Int
    let previousReps: Int
    @Published var kg: Int?
    @Published var reps: Int?
    @Published var isCompleted: Bool
    
    init(id: Int, previousKg: Int, previousReps: Int, kg: Int? = nil, reps: Int? = nil, isCompleted: Bool = false) {
        self.id = id
        self.previousKg = previousKg
        self.previousReps = previousReps
        self.kg = kg
        self.reps = reps
        self.isCompleted = isCompleted
    }
}
