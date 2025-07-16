import SwiftUI

// Home View : 앱의 첫화면, 로고와 "촬영하기" 버튼을 포함
struct HomeView: View {
    var body: some View {
        // NavigationView를 이용하여 다른 화면으로 이동이 가능한 네비게이션 구조를 생성
        NavigationView {
            VStack { // 화면의 구조를 수직으로 정렬
                Spacer() // 윗 부분에 빈 공간을 추가하여 로고를 중앙 배치
                // 로고 이미지 설정
                Image("logo") // 'Logo'라는 이름의 이미지 로드
                    .resizable() // 이미지 크기를 조정 가능하도록 설정
                    .aspectRatio(contentMode: .fit) // 이비지의 비율 유지하며 화면에 맞게 조절
                    .frame(width: 400, height: 400) // 이미지 크기 고정 (400 400)
                Spacer() // 아랫부분에 빈 공간을 추가하여 버튼 위치를 조정
                
                
                
                // 촬영하기 버튼 -> 온보딩 뷰로 이동 : 네비게이션 링크 방식
                NavigationLink(destination: OnboardingView()) {
                    // 버튼의 텍스트 & 스타일 설정
                    Text("촬영하기")
                        .foregroundColor(.white) // 텍스트 색상 흰색
                        .frame(width: 200, height: 50) // 버튼 크기 200 50
                        .background(Color.black) // 버튼 배경색 검은색
                        .cornerRadius(10) // 버튼 모서리 둥글게 (반지름 10)
                }
                .padding() // 버튼 주위 여백
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // iPad 등에서 단순한 네비게이션 스타일로 설정
    }
}

// SwiftUI 미리보기
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView() // 미리보기에 표시될 화면으로 HomeView를 설정
    }
}
