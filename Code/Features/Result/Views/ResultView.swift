import SwiftUI

// ResultView : 사진 촬영 결과를 보여주는 화면
struct ResultView: View {
    
    // ViewModel : 결과 화면의 상태와 동작을 관리
    @StateObject private var viewModel = ResultViewModel()
    
    // 병합된 이미지 (사용자가 촬영한 이미지)
    let mergedImage: UIImage
    
    // 변수 리스트
    // showingQRView : 큐알 화면
    // showingHomeView : 홈 뷰
    
    //화면 전환 상태
    @State private var showingQRView = false // QR 코드 화면 표시 여부
    @State private var showingHomeView = false // 홈 화면 표시 여부
    
    // 선택된 프레임의 인덱스
    @State private var selectedFrameIndex = 0
    
    // 프로세서
    let processor = ImageProcessor() // 화면 상단 여백
    
    var body: some View {
        VStack {
            // 병합된 사용자 이미지 표시
            Spacer(minLength: 30)
            GeometryReader { geometry in
                ZStack {
                    // 병합 이미지
                    Image(uiImage: mergedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit) // 이미지 비율 유지
                        .padding(.bottom, 180.0) // 하단 여백
                        .frame(width: geometry.size.width, height: geometry.size.height - 255) // 프레임 크기
                        .navigationBarHidden(true) // 네비게이션 바 숨김
                    
                    // 선택된 프레임 이미지 로딩
                    if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
                        Image(uiImage: frameImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 이미지 비율 유지
                            .frame(width: geometry.size.width, height: geometry.size.height - 200) // 프레임 크기
                            .navigationBarHidden(true) // 네비게이션 바 숨김
                    } else {
                        // 프레임 이미지가 없는 경우 오류 메시지 표시
                        Text("프레임 이미지를 불러올 수 없습니다.")
                            .foregroundColor(.red) // 오류 메시지 색상
                            .navigationBarHidden(true) // 네비게이션 바 숨김
                    }
                }
                
                VStack(alignment: .center) {
                    Spacer() // 화면 아래쪽 여백
                    
                    // 프레임 선택 뷰
                    FrameSelectionView(selectedFrameIndex: $selectedFrameIndex)
                        .padding(.bottom, 30.0) // 하단 여백
                    
                    // 버튼 액션 뷰
                    ButtonActionView(
                        viewModel: viewModel, // 결과 화면의 ViewModel
                        showingHomeView: $showingHomeView, // 홈 화면의 상태 바인딩
                        showingQRView: $showingQRView, // QR 코드 화면 상태 바인딩
                        mergedImage: mergedImage, // 병합된 이미지 전달
                        selectedFrameIndex: selectedFrameIndex, // 선택된 프레임 인덱스 전달
                        processor: processor // 이미지 프로세서 전달
                    )
                    .padding(.bottom, 20.0) // 버튼 하단 여백
                }
            }
            .padding(.all) // 전체 여백
            .edgesIgnoringSafeArea(.all) // 전체 화면 사용
        }
    }
}

// MobileResultView 미리보기
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        // "4cut_example"이미지가 있을 경우, 해당 이미지를 병합 이미지로 사용
        if let exampleImage = UIImage(named: "4cut_example") {
            ResultView(mergedImage: exampleImage)
        } else {
            // 이미지가 없을 경우, 기본 UIImage 사용
            ResultView(mergedImage: UIImage())
        }
    }
}
