
import SwiftUI

struct CardGameView: View {
    @StateObject var model = CardGameViewModel()
    
    var body: some View {
        VStack {
            HandView(hand: model.handOfCardsP2)
                .zIndex(1)
                .environmentObject(model)
            
            PlayAreaView(model.getPlayArea(by: .yonder))
                .dropReceiver(for: model.getPlayArea(by: .yonder),
                              model: model)
            PlayAreaView(model.getPlayArea(by: .there))
                .dropReceiver(for: model.getPlayArea(by: .there),
                              model: model)
            PlayAreaView(model.getPlayArea(by: .here))
                .dropReceiver(for: model.getPlayArea(by: .here),
                              model: model)
            
            HandView(hand: model.handOfCardsP1)
                .zIndex(1)
                .environmentObject(model)
        }
    }
}

struct CardGameView_Previews: PreviewProvider {
    static var previews: some View {
        CardGameView()
    }
}
