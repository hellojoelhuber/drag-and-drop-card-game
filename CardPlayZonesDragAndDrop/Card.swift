
import Foundation
import DragAndDrop

struct Card: Identifiable, Dragable {
    let id: Int
    let deck: Deck
    let cardName: String
    let canPlay: [PlayableArea?]
    let contents: CardContents
    
    enum Deck {
        case home
        case visitor
    }
}

enum CardContents: String {
    case sun
    case moon
}
