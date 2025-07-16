import SwiftUI

// QRCodeSheetView: QR 코드 화면을 표시하는 뷰
struct QRCodeSheetView: View {
    // ViewModel: QR 코드 이미지와 상태를 관리
    @ObservedObject var viewModel: ResultViewModel
    
    // 상태 바인딩: 홈 화면 및 QR 코드 화면 표시 여부를 관리
    @Binding var showingHomeView: Bool
    @Binding var showingQRView: Bool
    
    var body: some View {
        // QR 코드 이미지가 생성된 경우
        if let qrImage = viewModel.qrCodeImage {
            VStack {
                Spacer() // 상단 여백
                
                // QR 코드 만료 알림 텍스트
                Text("사진은 3시간 뒤에 만료됩니다! 꼭 바로 다운받아주세요")
                    .font(.custom("Pretendard-SemiBold", size: 20)) // 중앙 정렬
                Spacer() // QR 코드 상단 여백
                
                // QR 코드 이미지
                Image(uiImage: qrImage)
                    .resizable() // 이미지 크기 조정 가능
                    .interpolation(.none) // 이미지 스케일링 시 선명도 유지
                    .scaledToFit() // 화면 크기에 맞게 조절
                    .scaleEffect(0.6) // 크기 비율 0.6
                Spacer() // QR 코드 하단 여백
                
                // "홈으로" 버튼
                Button("홈으로") {
                    // QR 코드 화면 닫기
                    showingQRView = false
                    
                    // 약간의 지연 후 홈 화면으로 이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showingHomeView = true
                    }
                }
                .foregroundColor(.white) // 버튼 텍스트 색상
                .frame(width: 140, height: 50) // 버튼 크기 (140 50)
                .background(Color.black) // 버튼 배경색
                .cornerRadius(10) // 버튼 모서리 둥글게
                .padding(.bottom, 30) // 버튼 하단 여백
                
                // 홈 화면 전환
                .fullScreenCover(isPresented: $showingHomeView) {
                    HomeView()
                }
            }
        } else {
            // QR코드 이미지가 아직 생성되지 않은 경우
            Text("QR 코드 생성 중...")
                .font(.custom("Pretendard-SemiBold", size: 20)) // 폰트 정의
        }
    }
}

// QRCodeSheetView 미리보기
struct QRCodeSheetView_Previews: PreviewProvider {
    static var previews: some View {
        // StatefulPreviewWrapper를 사용하여 상태를 제어
        StatefulPreviewWrapper(false) { showingHomeView in
            StatefulPreviewWrapper(false) { showingQRView in
                QRCodeSheetView(
                    viewModel: ResultViewModel(), // 결과 화면의 ViewModel
                    showingHomeView: showingHomeView, // 홈 화면의 상태 바인딩
                    showingQRView: showingQRView // QR 코드 화면 상태 바인딩
                )
            }
        }
    }
}
