import SwiftUI

// TakePhotoView: 사진 촬영 화면
struct TakePhotoView: View {
    // CameraViewModel 인스턴스를 상태로 관리 (사진 촬영 및 타이머 관리)
    @StateObject var cameraViewModel = CameraViewModel()
    
    // ResultView가 표시되는 상태 관리
    @State private var isPresentingResultView = false
    
    var body: some View {
        ZStack {
            // 카메라 뷰를 배경으로 설정
            CustomCameraView(viewModel: cameraViewModel)
            
            VStack {
                // 타이머가 작동중인 경우 남은 시간을 화면에 표시
                if cameraViewModel.remainingTime > 0 {
                    VStack{
                        
                        Text("남은 시간") // 타이머 텍스트
                            .font(.custom("Pretendard-SemiBold", size: 40))
                            .foregroundColor(.black)
                            .padding(.top,40) // 상단 여백 추가
                        Text("\(cameraViewModel.remainingTime)") // 남은 시간을 숫자로 표시
                            .font(.custom("Pretendard-SemiBold", size: 100))
                            .foregroundColor(.black)

                    }
            
                } else {
                    // 타이머가 종료된 경우 카메라 캡쳐 아이콘 표시
                    Text("📸")
                        .font(.title)
                        .padding()
                }
                Spacer() // 상단 여백 추가
                
                // 현재 캡쳐된 이미지 개수 표시 (4장 중 현재 개수)
                Text("\(cameraViewModel.capturedImages.count)/4")
                    .foregroundColor(.white) // 텍스트 색상 설정
                    .font(.custom("Pretendard-SemiBold", size: 30))
                    .padding() // 내부 여백 추가
                    .padding(.horizontal,17) // 좌우 여백 추가
                    .background(Color.black.opacity(0.9)) // 반투명 검은색 배경
                    .cornerRadius(36) // 둥근 모서리 처리
                    .padding(.bottom, 40) // 상단 Safe Area를 고려한 여백 추가
                // 타이머 표시

            }
            .foregroundColor(.white) // 텍스트 기본 색상을 흰색으로 설정

        }
        .onAppear {
            // 화면이 나타날 때 카메라 캡처 시작
            cameraViewModel.startCapturing()
        }
        .fullScreenCover(isPresented: $isPresentingResultView) {
            // ResultView에 mergedImage가 nil인 경우에 대한 처리를 추가
            // 촬영 결과를 보여주는 ResultView를 표시
            if let exampleImage = UIImage(named: "4cut_example") {
                // 병합된 이미지가 없을 경우 기본 이미지 표시
                ResultView(mergedImage: cameraViewModel.mergedImage ?? exampleImage)
            } else {
                // 기본 이미지를 불러오지 못한 경우 빈 UIImage전달
                ResultView(mergedImage: UIImage())
            }
            
        }
        .onChange(of: cameraViewModel.mergedImage) { _ in
            // mergedImage의 상태 변화가 감지되면, isPresentingResultView를 true로 설정하여 sheet를 표시합니다.
            // 병합된 이미지 상태가 변경되면 ResultView를 표시
            print(cameraViewModel.mergedImage) // 병합된 이미지를 로그로 출력
            isPresentingResultView = cameraViewModel.mergedImage != nil
        }
    }
}


// SwiftUI 미리보기
struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
