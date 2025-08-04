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



class WorkoutViewModel2: ObservableObject {

    @Published var isWorkoutStarted: Bool = false
    @Published var isResting: Bool = false
    @Published var restDuration: Int = 10 // seconds
    @Published var remainingTime: Int = 0
    @Published var showSummary: Bool = false
    
    @Published var state: WorkoutStage = .initial
        
    func startWorkout() {
        state = .started
    }

    func completeSet(for set: WorkoutRowViewModel) {
        set.isCompleted = true
//        currentPillState = .restPicker
    }

    func selectRestDuration(_ duration: Int) {
        restDuration = duration
        remainingTime = duration
        isResting = true
//        currentPillState = .countdown
        startRestCountdown()
    }

    private func startRestCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                timer.invalidate()
                self.isResting = false
                self.advanceToNextSet()
            }
        }
    }

    func advanceToNextSet() {
        showSummary = true
//        currentPillState = .summary
    }

    func resetWorkout() {
        for set in sets {
            set.kg = nil
            set.reps = nil
            set.isCompleted = false
        }
        isWorkoutStarted = false
        isResting = false
        showSummary = false
//        currentPillState = .start
    }
}
