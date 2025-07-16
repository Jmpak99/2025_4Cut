import SwiftUI

// ReusableButton : 다양한 상황에서 재사용 가능한 커스텀 버튼 컴포넌트
struct ReusableButton: View {
    // 버튼의 텍스트
    let title: String
    
    // 버튼이 눌렸을 때 실행할 액션
    let action: () -> Void
    
    // 버튼의 가로 크기 (기본값 140
    var boxWidth: CGFloat = 140
    
    var body: some View {
        // 버튼 디자인
        Button(action: action) { // 버튼 클릭 시 액션 실행
            Text(title) // 버튼에 표시할 텍스트
                .font(.system(size: 18, weight: .bold)) // 텍스트와 폰트 크기
                .foregroundColor(.white) // 텍스트 색상 (흰색)
                .frame(width: boxWidth, height: 50) // 버튼 크기
                .background(Color.black) // 버튼 배경색 (검정색)
                .cornerRadius(10) // 모서리를 둥글게
        }
    }
}

// ReusableButton의 미리보기
struct ReusableButton_Previews: PreviewProvider {
    static var previews: some View {
        // 미리보기에서 버튼을 테스트
        ReusableButton(title: "홈으로") {
            print("Button pressed") // 버튼 클릭 시 동작을 출력
        }
    }
}
