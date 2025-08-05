struct WorkoutRowCompletedViewModel: Identifiable {
    let id: Int
    let kgAndRep: String

    init(_ rowVm: WorkoutRowViewModel) {
        self.id = rowVm.id
        self.kgAndRep = "\(rowVm.kg ?? rowVm.previousKg)kg x \(rowVm.reps ?? rowVm.previousReps)"
    }
}
