import Combine
import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var progress: CGFloat = 0
    @Published var state: WorkoutStage = .initial
    @Published var timeMMSS: String = "00:00"
    @Published var restMMSS: String = "00:00"
    @Published var restProgress: Double = 0.0
    @Published var shouldRestartWorkout: Bool = false
    @Published var shouldType: Bool = false
    var restTime = 0.0

    /*
     TODO: Due to limited time and scope of this project, the following can be done later:
     1. Create *WorkoutSet* model,
     2. persistently store using SwiftData,
     3. Bind kg & reps which is otherwise free on a TextField with native keyboard (we are using custom keyboard here).
     */
    @Published var sets: [WorkoutRowViewModel] = []
    
    init() {
        sets = [
            WorkoutRowViewModel(id: 1, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 2, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 3, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 4, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 5, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 6, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 7, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 8, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 9, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 10, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) },
            WorkoutRowViewModel(id: 11, previousKg: 15, previousReps: 10) { [weak self] id, f in self?.startTyping(id, f) }
        ]
    }

    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0

    private var restTimer: Timer?
    private var restElapsedTime: TimeInterval = 0
    
    private var typingId: Int?
    private var typingField: CustomTextFieldType?

    func startWorkout(_ isNewTimer: Bool = false) {
        state = .started
        progress = 1
        restTimer?.invalidate()
        restTimer = nil
        restProgress = 0
        guard isNewTimer else { return }
        elapsedTime = 0
        timeMMSS = "00:00"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
            self.timeMMSS = self.formatTimeMMSS(self.elapsedTime)
        }
    }
    
    func finishWorkout() {
        state = .initial
        progress = 0
        timer?.invalidate()
        timer = nil
        restTimer?.invalidate()
        restTimer = nil
        restProgress = 0
        elapsedTime = 0
        timeMMSS = "00:00"
    }
    
    func startTyping(_ id: Int, _ field: CustomTextFieldType) {
        typingId = id
        typingField = field
        shouldType = true
        print("\(id) \(field)")
    }
    
    func startType() {
        state = .typing
        progress = 1
    }
    
    func pickRestTime() {
        state = .picker
        progress = 1
    }
    
    func startRest(for restTime: RestTimeSeconds) {
        state = .resting
        progress = 1
        restTimer?.invalidate()
        restElapsedTime = 0
        shouldRestartWorkout = false
        let duration = TimeInterval(restTime.rawValue)
        self.restTime = duration
        restMMSS = formatTimeMMSS(duration)
        restProgress = 1
        var remaining = duration
        restTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            self.restElapsedTime += 1
            remaining -= 1
            self.restMMSS = self.formatTimeMMSS(max(remaining, 0))
            self.restProgress = restElapsedTime // duration  // max(remaining / duration, 0)
            if restElapsedTime == duration {
                timer.invalidate()
                self.rested()
            }
        }
    }
    
    private func formatTimeMMSS(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func rested() {
        shouldRestartWorkout = true
    }
    
    var completedDateDisplay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        return "Today, " + dateFormatter.string(from: Date())
    }
    
}
