import SwiftUI

struct WorkoutRowView: View {
    @ObservedObject var vm: WorkoutRowViewModel
    @State var opacitykg: CGFloat = 0.2
    @State var opacityReps: CGFloat = 0.2

    var body: some View {
        HStack(spacing: 14) {
            // Set id
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(0.2))
                Text("\(vm.id)")
                    .font(.body)
            }
            .frame(width: 40, height: 40)
            
            // Previous
            Text("\(vm.previousKg) x \(vm.previousReps)")
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 70, alignment: .leading)
                .opacity(0.5)
            
            // Kg
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(opacitykg))
                Text(vm.kg)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            .frame(width: 50, height: 40)
            .padding(.horizontal, 5)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .onTapGesture {
                vm.isKgFocused = true
                vm.startTyping(.kg)
            }
            
            
            // Reps
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.secondary.opacity(opacityReps))
                Text(vm.reps)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            .frame(width: 50, height: 40)
            .padding(.horizontal, 5)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .onTapGesture {
                vm.isRepsFocused = true
                vm.startTyping(.reps)
            }
            
            // Completed
            Toggle("", isOn: $vm.isCompleted)
                .frame(width: 50, height: 40)
            
            // Space
            Spacer()
        }
        .onChange(of: vm.isCompleted, { oldValue, newValue in
            guard oldValue != newValue else { return }
            vm.onChangeOfCompleted(newValue)
        })
        .onChange(of: vm.isKgFocused, { oldValue, newValue in
            guard oldValue != newValue else { return }
            withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                opacitykg = newValue ? 1 : 0.2
            }
        })
        .onChange(of: vm.isRepsFocused, { oldValue, newValue in
            guard oldValue != newValue else { return }
            withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                opacityReps = newValue ? 1 : 0.2
            }
        })
    }
}

#Preview {
    WorkoutRowView(vm: WorkoutRowViewModel(id: 1, previousKg: "15", previousReps: "10", kg: "", reps: "", isCompleted: false, typing: { id, field in }, onCompletedChange: { id, isCompleted in }))
}
