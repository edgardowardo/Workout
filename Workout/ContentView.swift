import SwiftUI

struct ContentView: View {
    var body: some View {
        WorkoutContainerView()
    }
}


struct cContentView: View {
    @State private var progress: CGFloat = 0
    var body: some View {
        List {
            Section("Preview") {
                ZStack {
                    ExpandableHorizontalGlassContainer(
                        placeAtLeading: false,
                        size: .init(width: 130, height: 55),
                        progress: progress,
                        labelProgressPadding: -35.0
                    ) {
//                        ForEach(RestTimeSeconds.allCases, id: \.self) { value in
//                            Text(value.description)
//                        }
                        Text("Finish")
//                            .containerValue(\.tintColor, .green.opacity(progress))
                            .containerValue(\.contentPadding, -25)

                        Text("0:02")
                            .containerValue(\.contentPadding, -25)

//                        Image(systemName: "suit.heart.fill")
//                            .containerValue(\.unionID, "0")
//                            .containerValue(\.contentPadding, -7.5)
//                        Image(systemName: "square.and.arrow.up.fill")
//                        Image(systemName: "timer")
//                            .containerValue(\.contentPadding, -7.5)
//                            .containerValue(\.unionID, "0")
//                            .containerValue(\.contentPadding, -7.5)

                    } label: {
                        ZStack {
//                            Text("Edit")
//                            Image(systemName: "ellipsis")
                            Label("Start", systemImage: "play.fill")
                                .opacity(1 - progress)
//                            Text("Done")
//                            Image(systemName: "xmark")
                            Image(systemName: "timer")
                                .opacity(progress)
                        }
                        
                    }
                    .foregroundStyle(.primary)
                    .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .background {
                    Image(.background)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .clipShape(.rect(cornerRadius: 25))
            }
            
            Section("Properties") {
                Slider (value: $progress)
                
                Button("Toggle Actions") {
                    withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                        progress = progress == 0 ? 1 : 0
                    }
                }
                .buttonStyle(.glassProminent)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ExpandableHorizontalGlassContainer<Content: View, Label: View>: View, Animatable {
    var placeAtLeading = false
    var isInteractive = true
    var size: CGSize = .init(width: 55, height: 55)
    var progress: CGFloat
    var labelProgressPadding: CGFloat = 0 // padding on the label when progress is 1.0
    @ViewBuilder var content: Content
    @ViewBuilder var label: Label
    @State private var labelPosition: CGRect = .zero
    @Namespace private var animation
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    var body: some View {
        GlassEffectContainer(spacing: spacing) {
            HStack(spacing: spacing) {
                if placeAtLeading {
                    LabelView()
                }
                
                ForEach(subviews: content) { subview in
                    let unionID = subview.containerValues.unionID
                    let contentPadding = subview.containerValues.contentPadding
                    let width = size.width + (contentPadding * 2)
                    let tintColor = subview.containerValues.tintColor
                    subview
                        .blur(radius: 15 * scaleProgress)
                        .opacity(progress)
                        .frame(width: width, height: size.height)
                        .glassEffect(.regular.interactive(isInteractive).tint(tintColor), in: .capsule)
                        .glassEffectUnion(id: unionID, namespace: animation)
                        .allowsHitTesting(progress == 1)
                        .visualEffect { [labelPosition] content, proxy in
                            content.offset(x: offsetX(proxy: proxy, labelPosition: labelPosition))
                        }
                        .fixedSize()
                        .frame(width: width * progress)
                }
                
                if !placeAtLeading {
                    LabelView()
                }
            }
        }
        .coordinateSpace(.named("container"))
        .scaleEffect(x: 1 + scaleProgress * 0.3, y: 1 - scaleProgress * 0.3, anchor: .center)
    }
    
    nonisolated
    func offsetX(proxy: GeometryProxy, labelPosition: CGRect) -> CGFloat {
        let minX = labelPosition.minX - proxy.frame(in: .named("container")).minX
        return minX - (minX * progress)
    }
    
    @ViewBuilder
    private func LabelView() -> some View {
        label
            .compositingGroup()
            .blur(radius: 15 * scaleProgress)
            .frame(width: size.width + (labelProgressPadding * 2) * progress, height: size.height)
            .glassEffect(.regular.interactive(isInteractive), in: .capsule)
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .named("container"))
            } action: { newValue in
                labelPosition = newValue
            }
    }
    
    var scaleProgress: CGFloat { progress > 0.5 ? (1 - progress) / 0.5 : (progress / 0.5) }
    var spacing: CGFloat { 10.0 * progress }
}

extension ContainerValues {
    @Entry var unionID: String? = nil
    @Entry var contentPadding: CGFloat = 0
    @Entry var tintColor: Color? = nil
}
