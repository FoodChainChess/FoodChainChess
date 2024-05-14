import SwiftUI

struct BoardView: View {
    let boardWidth: Int = 7
    let boardHeight: Int = 9
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(Colors.text)
                Spacer()
                PlayerProfilBoardView(imageSource: "", username: "Username 2").rotationEffect(.degrees(180))
                Spacer()
            }.padding()
            Spacer()
            VStack {
                ForEach(0..<boardHeight, id: \.self) { row in
                    HStack {
                        ForEach(0..<boardWidth, id: \.self) { col in
                            CellBoardView(row: row, col: col)
                        }
                    }
                }
            }
            .background(Color.white)
            Spacer()
            PlayerProfilBoardView(imageSource: "", username: "Username 1")
        }
    }
}

#Preview {
    BoardView()
}
