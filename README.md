# Card Game

This project was created as a samplie implementation of [SwiftUI Drag-and-Drop](https://github.com/hellojoelhuber/swiftui-drag-and-drop) library. This README is a mirror of my [personal website](https://www.joelhuber.com/documentation/documentation-drag-and-drop-card-game/).

![Card Game Drag-And-Drop Demo](https://github.com/hellojoelhuber/swiftui-drag-and-drop/blob/main/assets/media/documentation-dragdrop-card-game-demo.gif)

# Overview.

The card game project is a simple display of 3 playable areas (each player's "zone" plus the center of the table). 
* There are three (3) `DropReceiver`s, the two player zones and the central zone.
* The `Dragable` objects are the cards.

In this card game, there are 3 drop areas: here, there, yonder. Each card indicates which areas it can play in, and the possibility is that each card could be played in any combination of these. 

When a card drops on an area, it adds either a Sun or Moon to the area. Each area can only have 1 sun and 1 moon.

## Protocol: Dragable

Unsurprisingly, in the card game, the `Dragable` object is the `Card`. 

```
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
```

## ViewModifier: .dragable(...)

The `.dragable(object:onDragObject:onDropObject:)` modifier is applied on each card in the `HandView`.

```swift
    ForEach(hand) { card in
        CardView(card: card)
            .offset(x: CGFloat(((2 - card.id) * 60)),
                    y: 0)
            .dragable(object: card,
                      onDragObject: onDragCard,
                      onDropObject: onDropCard)                        
    }
```

#### onDragged

If the card is in one of the areas it is allowed to play in, and if the area does not have the card contents (sun, moon), then the shadow is green. If the area is illegal for the card, the result is a red shadow. And if no drop area is under the card, the shadow is blue.

```swift
// the onDragCard method
    func onDragCard(card: Dragable, position: CGPoint) -> DragState {
        model.getDragState(at: position, for: (card as! Card))
    }
    
// the ViewModel getDragState method
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
```

#### onDropObject

The card drop method lets the ViewModel `acceptCardDrop(for:at:)` determine the legality of the drop. Regardless of the result, the `onDropCard` method is returning false. This is fine because on a failure to play the card, the card will return to its original position with animation, and on success, the card is "discarded" and no longer exists anyway. 

```swift
    func onDropCard(card: Dragable, position: CGPoint) -> Bool {
        model.acceptCardDrop(card: (card as! Card),
                             at: position)
        return false
    }
    
    func acceptCardDrop(for card: Card, at position: CGPoint) {
        if let targetedPlayArea = getPlayArea(by: position),
           card.canPlay.compactMap({$0}).contains(targetedPlayArea.type),
           !targetedPlayArea.contents.contains(card.contents) {
            addElement(card.contents, to: targetedPlayArea)
            discardCard(card: card)
        }
    }
```

A nice bit of polish here would be adding an animation on successful card play.

## Protocol: DropReceiver

The `PlayArea` is the `DropReceiver`. It has properties for its type (here, there, yonder) and contents (sun, moon).

```swift
struct PlayArea: DropReceiver {
    var dropArea: CGRect?
    var type: PlayableArea
    var contents: [CardContents]
}
```

## Protocol: DropReceivableObservableObject

The `DropReceivableObservableObject` sets the `typealias` to `PlayArea` and then defines one variable per play area. The `setDropArea(_:on:)` method does a switch on `dropReceiver.type` to update the correct one.

```
class CardGameViewModel: DropReceivableObservableObject {
    typealias DropReceivable = PlayArea
    
    @Published var playAreaHere = PlayArea(type: .here, contents: [])
    @Published var playAreaThere = PlayArea(type: .there, contents: [])
    @Published var playAreaYonder = PlayArea(type: .yonder, contents: [])
    
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
    ...
}
```

## ViewModifier: .dropReceiver(for:model:)


Each play area is stored in its own variable, so the board setup looks like this:

```swift
    PlayAreaView(model.getPlayArea(by: .yonder))
        .dropReceiver(for: model.getPlayArea(by: .yonder),
                      model: model)
    PlayAreaView(model.getPlayArea(by: .there))
        .dropReceiver(for: model.getPlayArea(by: .there),
                      model: model)
    PlayAreaView(model.getPlayArea(by: .here))
        .dropReceiver(for: model.getPlayArea(by: .here),
                      model: model)
```

Each drop receiver is specifically named. To keep the code as similar as possible, a utility method exists to `getPlayArea(by type:)`:

```swift
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
```
