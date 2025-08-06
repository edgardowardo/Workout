import SwiftUI

struct WorkoutContainerView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var showingCompletedSheet = false

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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                    showingCompletedSheet = true
                                }
                            }
                        }
                        .containerValue(\.tintColor, .green)
                        .containerValue(\.contentPadding, -20)
                    Text(viewModel.timeMMSS)
                        .containerValue(\.contentPadding, -20)
                } else if viewModel.state == .picker {
                    ForEach(RestTimeSeconds.allCases, id: \.self) { value in
                        Text(value.description)
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.progress = 0
                                    viewModel.startRest(for: value)
                                }
                            }
                            .containerValue(\.contentPadding, -20)
                    }
                } else if viewModel.state == .resting {
                    Text(viewModel.restMMSS)
                        .containerValue(\.contentPadding, -20)
                    
                    Slider(value: $viewModel.restProgress, in: 0...viewModel.restTime)
                        .allowsHitTesting(false)
                } else if viewModel.state == .typing {
                    Text("Next")
                        .containerValue(\.contentPadding, -20)
                }
            } label: {
                ZStack {
                    if viewModel.state == .initial {
                        Label("Start", systemImage: "play.fill")
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.startWorkout(true)
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
                    } else if viewModel.state == .started || viewModel.state == .typing {
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
            .onChange(of: viewModel.shouldType) { oldValue, newValue in
                if newValue {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        viewModel.progress = 0
                        viewModel.startType()
                    }
                    viewModel.shouldType = false // Reset the trigger
                }
            }
            .onChange(of: viewModel.shouldRestartWorkout) { oldValue, newValue in
                if newValue {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        viewModel.progress = 0
                        viewModel.startWorkout()
                    }
                    viewModel.shouldRestartWorkout = false // Reset the trigger
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .foregroundStyle(.primary)
            .font(.title3)
                        
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showingCompletedSheet) {
            WorkoutCompletedView(viewModel: viewModel)
        }
    }
}

#Preview {
    WorkoutContainerView()
}
