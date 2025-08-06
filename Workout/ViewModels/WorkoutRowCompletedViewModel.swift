struct WorkoutRowCompletedViewModel: Identifiable {
    let id: Int
    let kgAndRep: String

    init(_ rowVm: WorkoutRowViewModel) {
        self.id = rowVm.id
        self.kgAndRep = "\(rowVm.kg.isEmpty ? rowVm.previousKg : rowVm.kg)kg x \(rowVm.reps.isEmpty ? rowVm.previousReps : rowVm.reps)"
    }
}
