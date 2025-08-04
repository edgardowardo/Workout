import SwiftUI

struct PillView: View {
    
    @ObservedObject var viewModel: WorkoutViewModel
    @Namespace private var animation
    @Namespace private var buttonToAnimate

    
    var body: some View {
        switch viewModel.state {
        case .initial:
            initialView
        default:
            startedView
        }
    }
        
    var initialView: some View {
        Button {
            withAnimation(.spring()) {
                viewModel.state = .started
            }
        } label: {
            Label("Start", systemImage: "play.fill")
                .frame(maxWidth: .infinity, maxHeight: 24)
                .padding(16)
//                .foregroundColor(.secondary)
                .foregroundColor(.white)
        }
        .glassEffect(
            .regular
                .interactive()
                .tint(.gray.opacity(0.8))
        )
        .matchedGeometryEffect(id: buttonToAnimate, in: animation)
    }
    
    var startedView: some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    viewModel.state = .initial
                }
            } label: {
                Text("Finish")
                    .frame(height: 24)
                    .padding(16)
//                    .foregroundColor(.secondary)
                    .foregroundColor(.white)
            }
            .glassEffect(
                .regular
                    .interactive()
//                    .tint(.purple.opacity(0.8))
            )
            .matchedGeometryEffect(id: buttonToAnimate, in: animation)
            
            Spacer()
                        
            Button {
                viewModel.state = .started
            } label: {
                Image(systemName: "timer")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(16)
                    .foregroundColor(.secondary)
            }
            .glassEffect(
                .regular
                    .interactive()
                    .tint(.white.opacity(0.3))
            )
        }
    }
}
