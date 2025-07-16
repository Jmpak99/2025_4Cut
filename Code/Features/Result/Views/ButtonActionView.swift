import SwiftUI

// ButtonActionView: 결과 화면의 하단 버튼들 (홈, QR 코드, 앨범 저장)을 관리하는 뷰
struct ButtonActionView: View {
    // ViewModel: 결과 화면에서 상태 및 동작을 관리
    @ObservedObject var viewModel: ResultViewModel
    
    // 상태 바인딩: 홈 화면 및 QR 코드 화면 표시 여부
    @Binding var showingHomeView: Bool
    @Binding var showingQRView: Bool
    
    // 내부 상태: 알림 표시 여부 및 알림 관련 텍스트
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // 외부에서 전달받는 데이터
    let mergedImage: UIImage  // 합성된 이미지
    let selectedFrameIndex: Int // 선택된 프레임 인덱스
    let processor: ImageProcessor // 이미지 처리기
    
    var body: some View {
        HStack(alignment: .center) { // 버튼을 수평으로 정렬
            Spacer() // 좌측 여백
            
            
            // "홈" 버튼
            ReusableButton(title: "홈",boxWidth:90) {
                showingHomeView = true // 홈 화면으로 전환
            }
            .fullScreenCover(isPresented: $showingHomeView) { // 홈 화면 전환 시 전체 화면으로 표시
                HomeView()
            }
            
            
            // "QR 코드" 버튼
            ReusableButton(title: "QR 코드",boxWidth:90) {
                showingQRView = true // QR 코드 화면 표시
                generateQRCode() // QR 코드 생성 함수 호출
            }
            .sheet(isPresented: $showingQRView) { // QR 코드 화면을 시트로 표시
                QRCodeSheetView(viewModel: viewModel, showingHomeView: $showingHomeView, showingQRView: $showingQRView)
            }
            
            
            // "앨범 저장" 버튼
            ReusableButton(title: "앨범 저장",boxWidth:90) {
                saveImgInGallery() // 이미지 저장 함수 호출
            }
            Spacer() // 우측 여백
        }
        .alert(isPresented: $showingAlert) { // 알림(Alert) 표시
            Alert(
                title: Text(alertTitle), // 알림 제목
                message: Text(alertMessage), // 알림 메시지
                dismissButton: .default(Text("확인")) // 확인 버튼

            )
        }
    }
    
    // QR 코드 생성 함수
    private func generateQRCode() {
        // 선택된 프레임 이미지를 불러옴
        if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
            // 사용자 이미지와 프레임 이미지를 합성
            if let frameMergedImage = processor.mergeImage(image: mergedImage, frameImage: frameImage) {
                viewModel.uploadImageAndGenerateQRCode(image: frameMergedImage) // Firebase에 업로드하고 QR 코드 생성
            } else {
                print("이미지 합치기에 실패했습니다.")
            }
        }
    }
    
    // 이미지 앨범에 저장하는 함수
    private func saveImgInGallery() {
        // 선택된 프레임 이미지를 불러옴
        if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
            // 사용자 이미지와 프레임 이미지를 합성
            if let frameMergedImage = processor.mergeImage(image: mergedImage, frameImage: frameImage) {
                // 합성된 이미지를 앨범에 저장
                viewModel.saveImageToAlbum(image: frameMergedImage) { success, error in
                    if success {
                        alertTitle = "저장 완료"
                        alertMessage = "이미지가 성공적으로 저장되었습니다."
                    } else if let error = error {
                        alertTitle = "저장 실패"
                        alertMessage = "앨범에 저장 실패: \(error.localizedDescription)"
                    }
                    showingAlert =  true // 알림 표시
                }
            } else {
                // 이미지 합성 실패 시 알림 설정
                alertTitle = "저장 실패"
                alertMessage = "이미지 합치기에 실패했습니다."
                showingAlert = true
            }
        } else {
            // 프레임 이미지 불러오기 실패 시 알림 설정
            alertTitle = "저장 실패"
            alertMessage = "프레임 이미지를 불러올 수 없습니다."
            showingAlert = true
        }
    }
}

// ButtonActionView 미리보기
struct ButtonActionView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(false) { showingHomeView in
            StatefulPreviewWrapper(false) { showingQRView in
                ButtonActionView(
                    viewModel: ResultViewModel(),
                    showingHomeView: showingHomeView,
                    showingQRView: showingQRView,
                    mergedImage: UIImage(),
                    selectedFrameIndex: 0,
                    processor: ImageProcessor()
                )
            }
        }
    }
}
