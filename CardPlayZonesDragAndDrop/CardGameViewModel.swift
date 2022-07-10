
import SwiftUI
import DragAndDrop

class CardGameViewModel: DropReceivableObservableObject {
    typealias DropReceivable = PlayArea
    
    @Published var playAreaHere = PlayArea(type: .here, contents: [])
    @Published var playAreaThere = PlayArea(type: .there, contents: [])
    @Published var playAreaYonder = PlayArea(type: .yonder, contents: [])
    @Published var handOfCardsP1 = [Card]()
    @Published var handOfCardsP2 = [Card]()
    
    init() {
        for card in 0..<5 {
            handOfCardsP1.append(Card(id: card,
                                      deck: .home,
                                    cardName: "Card \(card)",
                                    canPlay: [
                                        (Double.random(in: 0...1) < 0.5 ? .here : nil),
                                        (Double.random(in: 0...1) < 0.5 ? .there : nil),
                                        (Double.random(in: 0...1) < 0.5 ? .yonder : nil)
                                             ],
                                    contents: (Double.random(in: 0...1) < 0.5 ? .moon : .sun)
                                   )
            )
            
            handOfCardsP2.append(Card(id: card,
                                      deck: .visitor,
                                    cardName: "Card \(card)",
                                    canPlay: [
                                        (Double.random(in: 0...1) < 0.5 ? .here : nil),
                                        (Double.random(in: 0...1) < 0.5 ? .there : nil),
                                        (Double.random(in: 0...1) < 0.5 ? .yonder : nil)
                                             ],
                                    contents: (Double.random(in: 0...1) < 0.5 ? .moon : .sun)
                                   )
            )
        }
        
    }
    
    func getDragState(at position: CGPoint, for card: Card) -> DragState {
        if let targetedPlayArea = getPlayArea(by: position) {
            if card.canPlay.compactMap({$0}).contains(targetedPlayArea.type),
               !targetedPlayArea.contents.contains(card.contents) {
                return .accepted
            } else {
                return .rejected
            }
        }
        return .unknown
    }
    
    func acceptCardDrop(for card: Card, at position: CGPoint) {
        if let targetedPlayArea = getPlayArea(by: position),
           card.canPlay.compactMap({$0}).contains(targetedPlayArea.type),
           !targetedPlayArea.contents.contains(card.contents) {
            addElement(card.contents, to: targetedPlayArea)
            discardCard(card: card)
        }
    }
    
    func addElement(_ element: CardContents, to area: PlayArea) {
        switch area.type {
        case .here:
            if !playAreaHere.contents.contains(element) { playAreaHere.contents.append(element) }
        case .there:
            if !playAreaThere.contents.contains(element) { playAreaThere.contents.append(element) }
        case .yonder:
            if !playAreaYonder.contents.contains(element) { playAreaYonder.contents.append(element) }
        }
    }
    
    func discardCard(card: Card) {
        switch card.deck {
        case .home:
            if let index = handOfCardsP1.firstIndex(where: {$0.id == card.id}) {
                handOfCardsP1.remove(at: index)
            }
        case .visitor:
            if let index = handOfCardsP2.firstIndex(where: {$0.id == card.id}) {
                handOfCardsP2.remove(at: index)
            }
        }
    }
    
    func setDropArea(_ dropArea: CGRect, on dropReceiver: PlayArea) {
        switch dropReceiver.type {
        case .here:
            playAreaHere.updateDropArea(with: dropArea)
        case .there:
            playAreaThere.updateDropArea(with: dropArea)
        case .yonder:
            playAreaYonder.updateDropArea(with: dropArea)
        }
    }
    
    func getPlayArea(by position: CGPoint) -> PlayArea? {
        if playAreaHere.getDropArea()!.contains(position) {
            return playAreaHere
        }
        if playAreaThere.getDropArea()!.contains(position) {
            return playAreaThere
        }
        if playAreaYonder.getDropArea()!.contains(position) {
            return playAreaYonder
        }
        return nil
    }
    
    func getPlayArea(by type: PlayableArea) -> PlayArea {
        switch type {
        case .here:
            return playAreaHere
        case .there:
            return playAreaThere
        case .yonder:
            return playAreaYonder
        }
    }
}
