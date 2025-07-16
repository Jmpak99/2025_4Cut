import SwiftUI
/**
 IconTextComponent: SwiftUI 컴포넌트로, 아이콘과 텍스트를 수평으로 나란히 배치하는 구성 요소입니다.

 - 설명:
    - 이 컴포넌트는 HStack을 사용하여 아이콘과 텍스트를 가로로 정렬합니다.
    - 아이콘은 시스템 이미지(Image(systemName:))로 설정되고, 텍스트는 사용자 정의된 스타일을 적용합니다.
    - 사용자는 아이콘 이름, 텍스트 내용, 아이콘 색상, 텍스트 색상, 텍스트 크기를 원하는 대로 설정할 수 있습니다.

 - 매개변수:
    - iconName (필수): 표시할 시스템 이미지 아이콘의 이름을 전달합니다.
    - text (필수): 아이콘 옆에 표시할 텍스트를 전달합니다.
    - textColor (선택): 텍스트 색상을 지정합니다. 기본값은 .black(검정색)입니다.
    - iconColor (선택): 아이콘 색상을 지정합니다. 기본값은 .black(검정색)입니다.
    - textSize (선택): 텍스트의 글꼴 크기를 지정합니다. 기본값은 20입니다.

 - 예시: IconTextComponent(iconName: "cloud", text: "하이", textColor: .blue, iconColor: .red, textSize: 18)
 이 예시는 구름 아이콘과 "하이" 텍스트를 생성하며, 텍스트는 파란색, 아이콘은 빨간색, 텍스트 크기는 18로 설정됩니다.
 */
struct IconTextComponent: View {
    
    var iconName: String
    // 아이콘 옆에 표시할 텍스트 (필수 전달)
    var text: String
    
    // 텍스트 색상 (기본값: 검정색)
    var textColor: Color = .black
    
    // 아이콘 색상 (기본값: 검정색)
    var iconColor: Color = .black
    
    // 텍스트 크기 (기본값: 20)
    var textSize: CGFloat = 20

    var body: some View {
        // HStack: 아이콘과 텍스트를 수평으로 나란히 정렬
        HStack {
            Image(systemName: iconName)  // 시스템 아이콘 이름을 기반으로 이미지 표시
                .aspectRatio(contentMode: .fit) // 아이콘의 비율을 유지하며 화면에 맞게 조정
                .foregroundColor(iconColor) // 아이콘의 색상 설정
            Text(text)
                .font(.custom("Pretendard-SemiBold", size: textSize)) // 사용자 정의 글꼴 및 크기 적용
                .foregroundColor(textColor) // 텍스트 색상 설정
        }
    }
}

// 미리보기 설정
#Preview {
    IconTextComponent(iconName: "cloud", text: "하이")
}
