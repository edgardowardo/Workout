
enum RestTimeSeconds: Int, CaseIterable, CustomStringConvertible {
    case short = 30
    case medium = 60
    case long = 120
    
    var description: String {
        switch self {
        case .short:
            return "30 sec"
        case .medium:
            return "1 min"
        case .long:
            return "2 min"
        }
    }
}

enum WorkoutStage {
    case initial, started, typing, picker, resting
}

enum CustomTextFieldType {
    case kg, reps
}
