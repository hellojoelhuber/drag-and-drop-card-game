
import SwiftUI
import DragAndDrop

struct PlayArea: DropReceiver {
    var dropArea: CGRect?
    var type: PlayableArea
    var contents: [CardContents]
}
