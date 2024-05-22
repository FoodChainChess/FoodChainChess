import SwiftUI

struct CellBoardView: View {
    let row: Int
    let col: Int
    
    var body: some View {
        Rectangle()
            .fill(getColorByType())
            .frame(width: 40, height: 40)
    }
    
    func getColorByType() -> Color {
        //switch type {
        //    case .jungle: return Color.green
        //}
        return Color.green
    }
}

//#Preview {
//    CellBoardView(row: 1,col: 1)
//}
