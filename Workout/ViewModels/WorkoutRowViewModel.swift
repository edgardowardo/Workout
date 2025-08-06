import Combine

class WorkoutRowViewModel: ObservableObject, Identifiable {
    let id: Int
    let previousKg: String
    let previousReps: String
    @Published var kg: String
    @Published var reps: String
    @Published var isCompleted: Bool
    
    @Published var isKgFocused: Bool = false
    @Published var isRepsFocused: Bool = false

    let typing: ((_ id: Int, _ field: CustomTextFieldType) -> Void)
    
    init(id: Int, previousKg: String, previousReps: String, kg: String, reps: String, isCompleted: Bool = false, typing: @escaping ((_ id: Int, _ field: CustomTextFieldType) -> Void)) {
        self.id = id
        self.previousKg = previousKg
        self.previousReps = previousReps
        self.kg = kg
        self.reps = reps
        self.isCompleted = isCompleted
        self.typing = typing
    }
    
    func startTyping(_ field: CustomTextFieldType) {
        typing(id, field)
    }
    
}
