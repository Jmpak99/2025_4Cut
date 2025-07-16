import SwiftUI

// FrameSelectionView: 사용자가 선택할 수 있는 프레임
// 색상을 보여주는 뷰
struct FrameSelectionView: View {
    // 선택된 프레임 인덱스를 바인딩으로 전달받아 상태를 공유
    @Binding var selectedFrameIndex: Int
    
    var body: some View {
        // 프레임 선택 버튼을 수평으로 나열
        HStack(alignment: .center, spacing: 30) {
            // ForEach로 4개의 프레임 옵션 생성 (0부터 3까지)
            ForEach(0..<8) { index in
                Circle() // 각 프레임은 원형으로 표시
                    .frame(width: 50, height: 60) // 원의 크기 설정
                    .foregroundColor(frameColor(for: index)) // 인덱스에 따른 색상 설정
                    .overlay(
                        Circle() // 선택된 프레임을 강조 표시하는 테두리
                            .stroke(selectedFrameIndex == index ? .grayUniv : Color.clear, lineWidth: 3)
                    )
                    .onTapGesture {
                        // 사용자가 원을 터치(?) 하면 해당 프레임 인덱스로 업데이트
                        selectedFrameIndex = index
                    }
            }
        }
    }
    
    // 인덱스에 따라 프레임의 색상을 반환하는 함수
    private func frameColor(for index: Int) -> Color {
        switch index {
        case 0:
            return .skyBlueUniv // 하늘색
        case 1:
            return .mintUniv // 민트색
        case 2:
            return .black // 검정색
        case 3:
            return .gray // 회색
        case 4:
            return .brown
        case 5:
            return .green
        case 6:
            return .red
        default:
            return .clear // 기본값으로 투명색
        }
    }
}


// FrameSelectionView의 미리보기
struct FrameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        // StatefulPreviewWrapper를 사용하여 selectedFrameIndex 상태를 제어
        StatefulPreviewWrapper(0) { FrameSelectionView(selectedFrameIndex: $0) }
    }
}

// StatefulPreviewWrapper : 미리보기에서 상태 관리를 지원하는 Wrapper
struct StatefulPreviewWrapper<Value, Content: View>: View {
    // 상태 값
    @State var value: Value
    
    // 상태 값을 바인딩으로 전달받아 뷰를 생성하는 클로저
    let content: (Binding<Value>) -> Content

    // 초기화 함수
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: value) // 상태 초기화
        self.content = content
    }

    // 뷰 생성
    var body: some View {
        content($value) // 상태를 바인딩으로 전달
    }
}
