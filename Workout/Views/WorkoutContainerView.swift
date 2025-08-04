import SwiftUI

struct WorkoutContainerView: View {
    @StateObject private var viewModel = WorkoutViewModel()

    var body: some View {
        ZStack {

            WorkoutBackgroundView()
            
            List {
                Section("Bench Press (Dumbbell)") {
                    WorkoutView(viewModel: viewModel)
                }
                .foregroundStyle(.primary)
            }
            .scrollContentBackground(.hidden)
            
            ExpandableHorizontalGlassContainer(
                placeAtLeading: false,
                size: .init(width: 130, height: 55),
                progress: viewModel.progress,
                state: viewModel.state,
                labelProgressPadding: -35.0) {
                if viewModel.state == .started {
                    Text("Finish")
                        .onTapGesture {
                            withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                viewModel.finishWorkout()
                            }
                        }
                        .containerValue(\.tintColor, .green)
                        .containerValue(\.contentPadding, -20)
                    Text("0:02")
                        .containerValue(\.contentPadding, -20)
                } else if viewModel.state == .picker {
                    ForEach(RestTimeSeconds.allCases, id: \.self) { value in
                        Text(value.description)
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.progress = 0
                                    viewModel.startTimer(for: value)
                                }
                            }
                            .containerValue(\.contentPadding, -20)
                    }
                } else if viewModel.state == .resting {
                    Text("1:43")
                        .containerValue(\.contentPadding, -20)
                    
                    Slider (value: $viewModel.timeInterval, in: 0...60)
                }
            } label: {
                ZStack {
                    if viewModel.state == .initial {
                        Label("Start", systemImage: "play.fill")
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.startWorkout()
                                }
                            }
                            .opacity(1 - viewModel.progress)
                    } else if viewModel.state == .picker {
                        Image(systemName: "xmark")
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.progress = 0
                                    viewModel.startWorkout()
                                }
                            }
                            .opacity(viewModel.progress)
                    } else if viewModel.state == .started {
                        Image(systemName: "timer")
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.progress = 0
                                    viewModel.pickRestTime()
                                }
                            }
                            .opacity(viewModel.progress)
                    } else if viewModel.state == .resting {
                        Text("Skip")
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.progress = 0
                                    viewModel.startWorkout()
                                }
                            }
                            .opacity(viewModel.progress)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .foregroundStyle(.primary)
            .font(.title3)
                        
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WorkoutContainerView()
}
