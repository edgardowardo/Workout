import Combine
import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var progress: CGFloat = 0
    @Published var state: WorkoutStage = .initial
    @Published var mainMMSS: String = "00:00"
    @Published var restMMSS: String = "00:00"
    @Published var restProgress: Double = 0.0
    @Published var shouldRestartWorkout: Bool = false
    @Published var shouldType: Bool = false
    @Published var showingCompletedSheet = false
    @Published var isPickRestTimerState = false

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
            WorkoutRowViewModel(id: 1, previousKg: "15", previousReps: "10", kg: "", reps: "", isCompleted: false, typing: { [weak self] id, f in self?.startTyping(id, f) }, onCompletedChange: { [weak self] id, v in self?.onChangeOfCompleted(id, v) }),
            WorkoutRowViewModel(id: 2, previousKg: "15", previousReps: "10", kg: "", reps: "", isCompleted: false, typing: { [weak self] id, f in self?.startTyping(id, f) }, onCompletedChange: { [weak self] id, v in self?.onChangeOfCompleted(id, v) }),
            WorkoutRowViewModel(id: 3, previousKg: "15", previousReps: "10", kg: "", reps: "", isCompleted: false, typing: { [weak self] id, f in self?.startTyping(id, f) }, onCompletedChange: { [weak self] id, v in self?.onChangeOfCompleted(id, v) }),
            WorkoutRowViewModel(id: 4, previousKg: "15", previousReps: "10", kg: "", reps: "", isCompleted: false, typing: { [weak self] id, f in self?.startTyping(id, f) }, onCompletedChange: { [weak self] id, v in self?.onChangeOfCompleted(id, v) }),
            WorkoutRowViewModel(id: 5, previousKg: "15", previousReps: "10", kg: "", reps: "", isCompleted: false, typing: { [weak self] id, f in self?.startTyping(id, f) }, onCompletedChange: { [weak self] id, v in self?.onChangeOfCompleted(id, v) }),
            WorkoutRowViewModel(id: 6, previousKg: "15", previousReps: "10", kg: "", reps: "", isCompleted: false, typing: { [weak self] id, f in self?.startTyping(id, f) }, onCompletedChange: { [weak self] id, v in self?.onChangeOfCompleted(id, v) })
        ]
    }

    private var mainTimer: Timer?
    private var mainElapsedTime: TimeInterval = 0

    private var restTimer: Timer?
    private var restElapsedTime: TimeInterval = 0
    
    private var typingId: Int?
    private var typingField: CustomTextFieldType?

    
    func onChangeOfCompleted(_ id: Int, _ isCompleted: Bool) {

        if sets.allSatisfy(\.isCompleted) {
            showingCompletedSheet = true
            return
        }

        if isCompleted && !(state == .picker || state == .resting) {
            isPickRestTimerState = true
        }
    }
    
    func initial() {
        state = .initial
        for vm in sets {
            vm.isKgFocused = false
            vm.isRepsFocused = false
        }
    }
    
    func startWorkout() {
        state = .started
        progress = 1
        restTimer?.invalidate()
        restTimer = nil
        restProgress = 0
        
        guard mainTimer == nil else { return }
        
        mainTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.mainElapsedTime += 1
            self.mainMMSS = self.formatTimeMMSS(self.mainElapsedTime)
        }
    }
    
    func finishWorkout() {
        state = .initial
        progress = 0
        mainTimer?.invalidate()
        mainTimer = nil
        restTimer?.invalidate()
        restTimer = nil
        restProgress = 0
        mainElapsedTime = 0
        mainMMSS = "00:00"
    }
    
    func startTyping(_ id: Int, _ field: CustomTextFieldType) {
        typingId = id
        typingField = field
        shouldType = true
    }
    
    func startType() {
        state = .typing
        progress = 1
    }
    
    func type(_ text: String) {
        guard let id = typingId, let field = typingField else { return }
        switch field {
        case .kg:
            if text == "<" {
                guard sets[id - 1].kg.count > 0 else { return }
                sets[id - 1].kg.removeLast()
            } else {
                sets[id - 1].kg.append(text)
            }
        case .reps:
            if text == "<" {
                guard sets[id - 1].reps.count > 0 else { return }
                sets[id - 1].reps.removeLast()
            } else {
                sets[id - 1].reps.append(text)
            }
        }
    }
    
    func typeNext() {
        if typingField == .kg {
            typingField = .reps
            if let id = typingId {
                sets[id - 1].isKgFocused = false
                sets[id - 1].isRepsFocused = true
            }
        } else {
            if let id = typingId, id < sets.count {
                typingId = id + 1
                typingField = .kg
                sets[id - 1].isRepsFocused = false
                sets[id].isKgFocused = true
            }
        }
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
