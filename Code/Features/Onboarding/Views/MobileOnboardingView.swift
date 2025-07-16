import SwiftUI
import AVFoundation

// MobileOnboardingView: 사진 촬영 앱의 온보딩 화면으로, 사용자가 사진 촬영 전 필수 정보를 제공받는 화면
struct MobileOnboardingView: View {
    
    // State 변수: "촬영하기" 버튼을 눌렀을 때 촬영 화면으로 전환을 제어
    @State private var showingTakePhotoView = false
    
    // Environment 변수: 현재 뷰의 프레젠테이션 상태를 제어
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    // 상수: 제목 텍스트와 온보딩 설명 아이콘-텍스트 리스트, 프레임 이미지 이름
    private let titleText = "찍기전에 보고 갈까요?!"
    private let iconTexts = [
        ("timer", "타이머는 기본 6초 입니다 !"),
        ("camera", "촬영하기를 누르면 바로 촬영이 시작돼요 !"),
        ("photo.on.rectangle", "사진은 기본 4번 촬영돼요 !"),
        ("gear", "설정에서 카메라 접근을 허용해주세요 !"),
        ("arrow.uturn.backward", "뒤로가기 버튼으로 촬영 중단이 가능해요"),
        ("qrcode", "촬영이 끝나고 친구들과 QR을 공유할 수 있어요"),
    ]
    private let frameImageName = "4cut_exmaple_onboarding"
    
    
    // 뒤로가기 버튼 구성
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss() // 현재 화면을 닫고 이전 화면으로 돌아가기
        } label: {
            HStack {
                Image(systemName: "chevron.left") // 뒤로가기 화살표 아이콘
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.black)
                Text("뒤로") // "뒤로" 텍스트
                    .foregroundColor(Color.black)
            }
        }
    }
    
    
    var body: some View {
        VStack {
            // 제목 텍스트
            Text(titleText)
                .font(.custom("Pretendard-SemiBold", size: 30)) // 사용자 정의 폰트
                .foregroundColor(.black) // 텍스트 색상
                .padding(.top, 100.0) // 상단 여백 추가
                .padding(.bottom, 60.0) // 하단 여백 추가
            
            // 아이콘과 텍스트 리스트
            VStack(alignment: .leading, spacing: 10) { // 왼쪽 정렬 및 요소 간 간격 설정
                ForEach(iconTexts, id: \.0) { iconName, text in
                    IconTextComponent(iconName: iconName, text: text, textSize:16) // 아이콘-텍스트 컴포넌트 사용
                }
            }
            .padding(.bottom, 30.0) // 리스트 하단 여백 추가
            
            
            // 프레임 이미지
            if let frameImage = UIImage(named: frameImageName) { // 이미지가 존재할 경우
                Image(uiImage: frameImage)
                    .resizable() // 크기 조절 가능하도록 설정
                    .aspectRatio(contentMode: .fit) // 이미지 비율 유지하며 화면에 맞게 조정
                    .scaleEffect(0.8) // 이미지 크기 조정 (0.8)
            } else {
                // 이미지가 없을 경우 대체 텍스트 표시
                Text("프레임 이미지를 불러올 수 없습니다.")
                    .foregroundColor(.red) // 텍스트 색상 빨간색으로 설정
            }
            Spacer() // 화면의 나머지 공간을 빈 공간으로 채움
            
            
            // "촬영하기" 버튼
            Button("촬영하기") {
                showingTakePhotoView = true // 버튼을 누르면 촬영 화면으로 전환
            }
            .foregroundColor(.white) // 버튼 텍스트 색상
            .frame(width: 200, height: 50) // 버튼 크기 설정
            .background(Color.black) // 버튼 배경색
            .cornerRadius(10) // 버튼의 모서리를 둥글게
            .fullScreenCover(isPresented: $showingTakePhotoView) {
                TakePhotoView() // 촬영 화면을 풀 스크린으로 표시
            }
        }
        .onAppear {
            requestCameraPermission() // 뷰가 나타날 때 카메라 권한 요청
        }
        .navigationBarBackButtonHidden(true) // 기본 네비게이션 뒤로가기 버튼 숨김
        .navigationBarItems(leading: backButton) // 커스텀 뒤로가기 버튼 추가
    }
    
    
    // 카메라 권한 요청 함수
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("카메라 접근 허용됨") // 사용자가 카메라 접근을 허용한 경우
            } else {
                print("카메라 접근 거부됨") // 사용자가 카메라 접근을 거부한 경우
            }
        }
    }
}

// SwiftUI 미리보기
struct MobileOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        MobileOnboardingView() // MobileOnboardingView 화면을 미리보기로 표시
    }
}
