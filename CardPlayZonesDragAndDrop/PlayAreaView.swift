
import SwiftUI

struct PlayAreaView: View {
    let playArea: PlayArea
    let color: Color
    let width: Double
    let height: Double
    
    init(_ playAreaValue: PlayArea) {
        self.playArea = playAreaValue
        self.color = PlayAreaView.playAreaColor(playAreaValue.type)
        self.width = playAreaValue.type == .there ? 400 : 200
        self.height = playAreaValue.type == .there ? 250 : 100
    }
    
    static func playAreaColor(_ type: PlayableArea) -> Color {
        switch type {
        case .here:
            return .green
        case .there:
            return .blue
        case .yonder:
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(color)
                .brightness(0.3
                            + (playArea.contents.contains(.moon) ? -0.1 : 0)
                            + (playArea.contents.contains(.sun) ? 0.1 : 0)
                )
            HStack {
                ForEach(playArea.contents, id:\.self) { icon in
                    Image(icon.rawValue)
                        .resizableToFit()
                        .scaleEffect(0.5)
                }
            }
        }
        .frame(width: width, height: height)
    }
}

struct PlayAreaView_Previews: PreviewProvider {
    struct Preview: View {
        let playArea = PlayArea(type: .here, contents: [.moon, .sun])
        
        var body: some View {
            PlayAreaView(playArea)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
