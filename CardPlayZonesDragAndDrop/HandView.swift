
import SwiftUI
import DragAndDrop

struct HandView: View {
    @EnvironmentObject var model: CardGameViewModel
    let hand: [Card]
    
    var body: some View {
        ZStack {
            switch hand.count {
            case 0:
                CardView(card: Card(id: 0, deck: .home, cardName: "", canPlay: [], contents: .sun))
                    .opacity(0)
            default:
                ForEach(hand) { card in
                    CardView(card: card)
                        .offset(x: CGFloat(((2 - card.id) * 60)),
                                y: 0)
                        .dragable(object: card,
                                  onDragObject: onDragCard,
                                  onDropObject: onDropCard)
                        
                }
            }
        }
    }
    
    func onDragCard(card: Dragable, position: CGPoint) -> DragState {
        model.getDragState(at: position, for: (card as! Card))
    }
    
    func onDropCard(card: Dragable, position: CGPoint) -> Bool {
        model.acceptCardDrop(for: (card as! Card),
                             at: position)
        return false
    }
}

struct HandView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject var model = CardGameViewModel()
        
        var body: some View {
            HandView(hand: model.handOfCardsP1)
                .environmentObject(model)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
