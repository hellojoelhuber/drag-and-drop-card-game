
import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .strokeBorder(Color.black, lineWidth: DrawingConstants.outlineWidth)
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .inset(by: DrawingConstants.outlineWidth)
                .foregroundColor(.white)
            VStack {
                Image(card.contents.rawValue).resizableToFit()
                
                Spacer()
                
                HStack {
                    ForEach(card.canPlay, id:\.self) { area in
                        switch area {
                        case .here:
                            Image("house").resizableToFit()
                                .blending(color: .green)
                        case .there:
                            Image("high-grass").resizableToFit()
                                .blending(color: .blue)
                        case .yonder:
                            Image("evil-tree").resizableToFit()
                                .blending(color: .red)
                        case .none:
                            Image("house").resizableToFit()
                                .opacity(0)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(width: DrawingConstants.cardWidth,
               height: DrawingConstants.cardHeight)
        .clipped()
        
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let outlineWidth: CGFloat = 3
        
        static let cardWidth: Double = 100
        static let cardHeight: Double = 170
    }
}

struct CardView_Previews: PreviewProvider {
    struct Preview: View {
        
        var body: some View {
            CardView(card: Card(id: 0, deck: .home, cardName: "Hello", canPlay: [.here, .there, .yonder], contents: .sun))
        }
    }
    static var previews: some View {
        Preview()
    }
}
