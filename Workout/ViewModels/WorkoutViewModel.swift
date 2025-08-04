import Combine
import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var progress: CGFloat = 0
    @Published var state: WorkoutStage = .initial
    @Published var timeInterval: TimeInterval = 45

    @Published var sets: [WorkoutRowViewModel] = [
        WorkoutRowViewModel(id: 1, previousKg: 15, previousReps: 10),
        WorkoutRowViewModel(id: 2, previousKg: 15, previousReps: 10),
        WorkoutRowViewModel(id: 3, previousKg: 15, previousReps: 10)
    ]

    func startWorkout() {
        state = .started
        progress = 1
    }
    
    func finishWorkout() {
        // TODO: popup modal summary screen
        state = .initial
        progress = 0
    }
    
    func pickRestTime() {
        state = .picker
        progress = 1
    }
    
    func startTimer(for restTime: RestTimeSeconds) {
        state = .resting
        progress = 1
    }
}
