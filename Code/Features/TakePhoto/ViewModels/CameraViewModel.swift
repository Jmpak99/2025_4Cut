import SwiftUI
import AVFoundation

// CameraViewModel: 카메라 촬영 및 이미지 처리 로직을 관리하는 ViewModel
class CameraViewModel: ObservableObject {
    
    // 캡처된 이미지 리스트
    @Published var capturedImages: [UIImage] = []
    
    // 타이머의 남은 시간
    @Published var remainingTime = 0
    
    // 병합된 이미지
    @Published var mergedImage: UIImage? = nil
    
    // 총 촬영 완료 횟수
    @Published var count = 0

    // 캡처 액션 클로저 (카메라에서 실행할 동작을 정의)
    var captureAction: (() -> Void)?
    
    // 타이머 객체
    var timer: Timer?
    
    // 촬영된 이미지의 카운트
    var captureCount = 0 // 개선된 부분: 초기 캡처 카운트를 0으로 설정

    // 캡처 프로세스 시작
    func startCapturing() {
        // 실행 중인 타이머가 있다면 종료
        timer?.invalidate()
        captureCount = 0
        capturedImages.removeAll()
        remainingTime = 6 // 타이머 초기화
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer() // 타이머는 매 초마다 updateTimer()를 호출해 시간을 줄임
        }
    }
    
    
    // 시스템에 설치된 모든 폰트 출력 (디버깅용)
    func fontView(){
        for fontFamily in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                print(fontName)
            }
        }
    }

    // 타이머 업데이트
    func updateTimer() {
        if remainingTime > 0 {
            // 남은 시간 감소
            remainingTime -= 1
        } else {
            // 4회 촬영이 완료되지 않았다면 촬영 동작 실행
            if captureCount < 4 {
                captureAction?()
                remainingTime = 6 // 타이머 재설정
            } else {
                // 타이머 종료 및 이미지 병합 로직
                timer?.invalidate()
                timer = nil
                count+=1 // 촬영 완료 횟수 증가
                print("Capture complete, merging images.")
                self.mergedImage = self.mergeImages() // 이미지 병합
                // 상태 초기화 로직
                resetCameraState()
            }
        }
    }

    // 상태를 초기화하는 함수
    private func resetCameraState() {
        capturedImages = [] // 이미지 리스트 초기화
        remainingTime = 0 // 남은 시간 초기화 (0)
        captureCount = 0 // 촬영 카운트 초기화 (0)
    }
    
    // 4장의 이미지를 병합하는 함수
    func mergeImages() -> UIImage? {
        
        // 이미지가 4장 모두 캡쳐되었는지 확인
        guard capturedImages.count == 4 else {
            print("Captured images count does not match expected. Found: \(capturedImages.count)")
            return nil
        }
        
        // 이미지 좌우 반전
        let flippedImages = capturedImages.map { $0.withHorizontallyFlippedOrientation() ?? $0 }

        // 이미지 크기 조정 (1/2로 축소)
        let resizeWidth = capturedImages[0].size.width / 2
        let resizeHeight = capturedImages[0].size.height / 2
        let size = CGSize(width: resizeWidth * 2, height: resizeHeight * 2) // 캔버스 크기 설정
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        for (index, image) in capturedImages.enumerated() {
            // 이미지 리사이즈
            guard let resizedImage = image.resized(toWidth: resizeWidth) else {
                print("Failed to resize image at index \(index).")
                UIGraphicsEndImageContext() // 현재 이미지 컨텍스트를 종료합니다.
                return nil
            }
            
            // 그릴 위치 계산 (2 x 2 배치)
            let x = CGFloat(index % 2) * resizeWidth
            let y = CGFloat(index / 2) * resizeHeight
            resizedImage.draw(in: CGRect(x: x, y: y, width: resizeWidth, height: resizeHeight))
        }
        
        // 병합된 이미지 생성
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let merged = mergedImage {
            print("Image merging successful.")
            return merged
        } else {
            print("Failed to merge images.")
            return nil
        }
    }

}

// UIImage 확장 : 리사이즈 기능 추가
// 큰 이미지를 병합하기 전에 크기를 줄이는 함수
// 병합할 이미지 크기를 일정하게 맞추기 위해 사용됨
extension UIImage {
    // 주어진 너비로 이미지를 리사이즈
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
