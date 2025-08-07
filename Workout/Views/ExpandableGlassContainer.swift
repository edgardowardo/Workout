import SwiftUI

struct ExpandableGlassContainer<HorizontalContent: View, MenuContent: View, Label: View>: View, Animatable {
    var menuAlignment: Alignment = .bottom
    var isInteractive = true
    var isLabelAtLeading = false
    var labelSize: CGSize = .init(width: 55, height: 55)
    var labelProgressPadding: CGFloat = 0 // padding on the label when progress is 1.0
    var cornerRadius: CGFloat = 30
    var progress: CGFloat
    var state: WorkoutStage
    var isMenuContentVisible: Bool = false
    @ViewBuilder var horizontalContent: HorizontalContent
    @ViewBuilder var menuContent: MenuContent
    @ViewBuilder var label: Label
    @State private var labelPosition: CGRect = .zero
    @State private var menuContentSize: CGSize = .zero
    @Namespace private var animation
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    var body: some View {
        GlassEffectContainer(spacing: spacing) {

            let widthDiff = menuContentSize.width - labelSize.width
            let heightDiff = menuContentSize.height - labelSize.height
            let rWidth = widthDiff * menuContentOpacity
            let rHeight = heightDiff * menuContentOpacity

            ZStack(alignment: menuAlignment) {
                if isMenuContentVisible {
                    menuContent
                        .compositingGroup()
                        .scaleEffect(menuContentScale)
                        .blur(radius: 14 * blurProgress)
                        .opacity(menuContentOpacity)
                        .onGeometryChange(for: CGSize.self) {
                            $0.size
                        } action: { newValue in
                            menuContentSize = newValue
                        }
                        .fixedSize()
                        .frame(width: labelSize.width + rWidth,
                               height: labelSize.height + rHeight)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
                        .padding(.bottom, (labelSize.height + 8) * menuContentOpacity)
                }
                
                horizontalCompositeView
            }
        }
        .coordinateSpace(.named("container"))
        .scaleEffect(
            x: 1 + scaleProgress * 0.3,
            y: 1 - scaleProgress * 0.3,
            anchor: .center
        )
    }
    
    nonisolated
    func offsetX(proxy: GeometryProxy, labelPosition: CGRect) -> CGFloat {
        let minX = labelPosition.minX - proxy.frame(in: .named("container")).minX
        return minX - (minX * progress)
    }

    var horizontalCompositeView: some View {
        HStack(spacing: spacing) {
            if isLabelAtLeading {
                LabelView()
            }
            
            ForEach(subviews: horizontalContent) { subview in
                let unionID = subview.containerValues.unionID
                let horizontalContentPadding = subview.containerValues.horizontalContentPadding
                let verticalContentPadding = subview.containerValues.verticalContentPadding
                let width = labelSize.width + (horizontalContentPadding * 2)
                let height = labelSize.height + (verticalContentPadding * 2)
                let tintColor = subview.containerValues.tintColor
                subview
                    .blur(radius: 15 * scaleProgress)
                    .opacity(progress)
                    .frame(width: width, height: height)
                    .glassEffect(.regular.interactive(isInteractive).tint(tintColor), in: .capsule)
                    .glassEffectUnion(id: unionID, namespace: animation)
                    .allowsHitTesting(progress == 1)
                    .visualEffect { [labelPosition] content, proxy in
                        content.offset(x: offsetX(proxy: proxy, labelPosition: labelPosition))
                    }
                    .fixedSize()
                    .frame(width: (width * progress > 0 ? width * progress : 0))
            }
            
            if !isLabelAtLeading {
                LabelView()
            }
        }
    }
    
    @ViewBuilder
    private func LabelView() -> some View {
        label
            .compositingGroup()
            .blur(radius: 15 * blurProgress)
            .frame(width: labelWidth, height: labelSize.height)
            .glassEffect(.regular.interactive(isInteractive), in: .capsule)
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .named("container"))
            } action: { newValue in
                labelPosition = newValue
            }
    }
    
    var labelWidth: CGFloat { labelSize.width + (labelProgressPadding * 2) * progress }
    var scaleProgress: CGFloat { progress > 0.5 ? (1 - progress) / 0.5 : (progress / 0.5) }
    var spacing: CGFloat { 10.0 * progress }
    
    //
    // MARK: Menu related properties
    //
    var labelOpacity: CGFloat { min(progress / 0.35, 1) }
    var menuContentOpacity: CGFloat { max(progress - 0.35, 0) / 0.65 }
    var menuContentScale: CGFloat {
        let minAspectScale = min(labelSize.width / menuContentSize.width, labelSize.height / menuContentSize.height)
        return minAspectScale + (1 - minAspectScale) * progress
    }
    var blurProgress: CGFloat { progress > 0.5 ? (1 - progress) / 0.5 : progress / 0.5 }
    var offset: CGFloat {
        switch menuAlignment {
        case .bottom, .bottomLeading, .bottomTrailing: -75
        case .top, .topLeading, .topTrailing: 75
        default: 0
        }
    }
    var scaleAnchor: UnitPoint {
        switch menuAlignment {
        case .bottomLeading: .bottomLeading
        case .bottom: .bottom
        case .bottomTrailing: .bottomTrailing
        case .topLeading: .topTrailing
        case .top: .top
        case .topTrailing: .topLeading
        case .leading: .leading
        case .trailing: .trailing
        default: .center
        }
    }
}

extension ContainerValues {
    @Entry var unionID: String? = nil
    @Entry var horizontalContentPadding: CGFloat = 0
    @Entry var verticalContentPadding: CGFloat = 0
    @Entry var tintColor: Color? = nil
}

