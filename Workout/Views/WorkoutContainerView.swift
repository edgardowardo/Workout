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
            .onTapGesture {
                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                    guard viewModel.state == .typing else { return }
                    viewModel.progress = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.initial()
                    }
                }
            }
            
            ExpandableGlassView(
                labelSize: .init(width: 130, height: 55),
                labelProgressPadding: viewModel.state == .resting ? -15 : -35.0,
                progress: viewModel.progress,
                state: viewModel.state,
                isMenuContentVisible: viewModel.state == .typing) {
                    
                    horizontalContentView
                } menuContent: {
                    numericKeyboardView
                } label: {
                    labelView
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
            .onChange(of: viewModel.isPickRestTimerState) { oldValue, newValue in
                if newValue {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        viewModel.progress = 0
                        viewModel.pickRestTime()
                    }
                    viewModel.isPickRestTimerState = false
                }
            }
            .onChange(of: viewModel.isFinishedWorkoutState) { oldValue, newValue in
                if newValue {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        viewModel.finishWorkout()
                    }
                    viewModel.isFinishedWorkoutState = false
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .foregroundStyle(.primary)
            .font(.title3)
                        
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $viewModel.showingCompletedSheet) {
            WorkoutCompletedView(viewModel: viewModel)
        }
    }
    
    @ViewBuilder
    var horizontalContentView: some View {
        if viewModel.state == .started {
            Text("Finish")
                .onTapGesture {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        viewModel.finishWorkout()
                    }
                }
                .containerValue(\.tintColor, .green.opacity(0.6))
                .containerValue(\.horizontalContentPadding, -20)
            Text(viewModel.mainMMSS)
                .containerValue(\.horizontalContentPadding, -20)
        } else if viewModel.state == .picker {
            ForEach(RestTimeSeconds.allCases, id: \.self) { value in
                Text(value.description)
                    .onTapGesture {
                        withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                            viewModel.progress = 0
                            viewModel.startRest(for: value)
                        }
                    }
                    .containerValue(\.horizontalContentPadding, -20)
            }
        } else if viewModel.state == .resting {
            Text(viewModel.restMMSS)
                .containerValue(\.horizontalContentPadding, -20)
            
            Slider(value: $viewModel.restProgress, in: 0...viewModel.restTime)
                .containerValue(\.verticalContentPadding, -10)
                .allowsHitTesting(false)
                .onAppear {
                    UISlider.appearance().sliderStyle = .thumbless
                }
        } else if viewModel.state == .typing {
            Text("Next")
                .onTapGesture {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        viewModel.typeNext()
                    }
                }
                .containerValue(\.horizontalContentPadding, -20)
        }
    }
    
    var numericKeyboardView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ForEach(["1", "2", "3"], id: \.self) { num in
                    Button(action: { viewModel.type(num) }) {
                        Text(num)
                            .frame(width: 55, height: 55)
                            .font(.title)
                    }
                }
            }
            HStack(spacing: 12) {
                ForEach(["4", "5", "6"], id: \.self) { num in
                    Button(action: { viewModel.type(num) }) {
                        Text(num)
                            .frame(width: 55, height: 55)
                            .font(.title)
                    }
                }
            }
            HStack(spacing: 12) {
                ForEach(["7", "8", "9"], id: \.self) { num in
                    Button(action: { viewModel.type(num) }) {
                        Text(num)
                            .frame(width: 55, height: 55)
                            .font(.title)
                    }
                }
            }
            HStack(spacing: 12) {
                Button(action: { /* handle space tap */ }) {
                    Text("")
                        .frame(width: 55, height: 55)
                        .font(.title3)
                }
                Button(action: { viewModel.type("0") }) {
                    Text("0")
                        .frame(width: 55, height: 55)
                        .font(.title)
                }
                Button(action: { viewModel.type("<") }) {
                    Text("<")
                        .frame(width: 55, height: 55)
                        .font(.title)
                }
            }
        }
        .padding(20)
    }
    
    var labelView: some View {
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
            } else if viewModel.state == .started || viewModel.state == .typing {
                Image(systemName: "timer")
                    .onTapGesture {
                        if viewModel.state == .typing {
                            viewModel.keyboardDisappearing()
                            withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                viewModel.progress = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                    viewModel.pickRestTime()
                                }
                            }
                        } else {
                            withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                                viewModel.progress = 0
                                viewModel.pickRestTime()
                            }
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
    
}

#Preview {
    WorkoutContainerView()
}
