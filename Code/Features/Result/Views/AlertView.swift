import SwiftUI
import UIKit

// AlertView: UIKit의 UIAlertController를 SwiftUI에서 사용할 수 있도록 래핑한 구조체
struct AlertView: UIViewControllerRepresentable {
    // AlertView에서 사용할 사용자 정의 변수들
    var title: String // 알림창의 제목
    var message: String // 알림창의 메시지 내용
    var dismissButton: String // 알림창의 닫기 버튼 텍스트
    
    // UIViewController 생성: AlertView에서 사용될 UIViewController를 생성
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // 더미 뷰 컨트롤러 생성 (Alert를 표시하기 위해 필요)
    }
    
    // UIViewController 업데이트: 알림창(Alert)을 설정하고 표시
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // UIAlertController 초기화
        let alert = UIAlertController(
            title: title,           // 알림창 제목
            message: message,       // 알림창 메시지
            preferredStyle: .alert  // 알림창 스타일 (기본 .alert)
        )
        
        // 닫기 버튼 추가
        alert.addAction(UIAlertAction(title: dismissButton, style: .default, handler: nil))
        
        // 알림창 표시를 위한 UI 업데이트를 메인 스레드에서 실행
        DispatchQueue.main.async {
            // 알림창 표시
            uiViewController.present(alert, animated: true, completion: nil)
        }
    }
}
