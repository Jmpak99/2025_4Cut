import SwiftUI
import AVFoundation

// CustomCameraView: SwiftUI에서 커스텀 카메라를 제공하는 UIViewRepresentable
// iPhone / iPad의 카메라를 앱 안에 띄우는 역할
struct CustomCameraView: UIViewRepresentable {
    
    // CameraViewModel을 관찰하여 상태를 업데이트
    @ObservedObject var viewModel: CameraViewModel

      
//    func makeUIView(context: Context) -> UIView {
//        let coordinator = context.coordinator
//        viewModel.captureAction = coordinator.takePicture
//        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
//        context.coordinator.setupCameraSession()
//        return view
//    }
    
    // UIView를 생성하는 메서드
    func makeUIView(context: Context) -> UIView {
        let coordinator = context.coordinator // Coordinator 생성
        viewModel.captureAction = coordinator.takePicture // 캡처 액선 연결
        let view = UIView(frame: UIScreen.main.bounds) // 전체 화면 크기의 UIView 생성
        context.coordinator.setupCameraSession(for: view) // 카메라 세선 설정 (뷰를 인자로 전달)
        return view
    }

    // UIView 업데이트 (현재는 사용하지 않음)
    func updateUIView(_ uiView: UIView, context: Context) {}

    // Coordinator 생성
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    // Coordinator 클래스 정의
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        // CameraViewModel과 캡처 세션 관리
        var viewModel: CameraViewModel
        let captureSession = AVCaptureSession() // AVCapture 세션
        let photoOutput = AVCapturePhotoOutput() // 사진 출력

        // 초기화
        init(viewModel: CameraViewModel) {
            self.viewModel = viewModel
            super.init()
//            setupCameraSession()
        }

        // 카메라 세선 설정
        func setupCameraSession(for view: UIView) {
            captureSession.sessionPreset = .photo // 사진 품질 설정
            
            // 카메라 장치 설정 (전면 카메라 사용)
            guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
                  captureSession.canAddInput(videoInput) else {
                      return
                  }

            captureSession.addInput(videoInput) // 입력 추가

            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput) // 출력 추가
            }

//            DispatchQueue.main.async {
//                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
//                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
//                    previewLayer.frame = CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height * (5/6))
//                    previewLayer.videoGravity = .resizeAspectFill
//                    window.layer.addSublayer(previewLayer)
//                }
//            }
            
            // 카메라 미리보기 레이어 설정
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
               previewLayer.frame = view.bounds // UIView의 크기와 일치
               previewLayer.videoGravity = .resizeAspectFill // 비율 유지하며 꽉 채움
               view.layer.addSublayer(previewLayer) // 미리보기 레이어를 UIView에 추가
            
            captureSession.startRunning() // 세션 시작
        }
        
        // 사진 캡처 메서드
        func takePicture() {
            let settings = AVCapturePhotoSettings() // 기본 설정 사용
            photoOutput.capturePhoto(with: settings, delegate: self)
        }

        
        // 사진 캡처 완료 콜백
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            // 사진 데이터를 UIImage로 변환
            guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
            
            
            DispatchQueue.main.async {
                // 최대 캡처 수(4장)를 초과하면 타이머 종료 및 병합 작업
                guard self.viewModel.captureCount < 4 else {
                    // 이미 4장의 사진을 캡처했다면, 타이머를 종료하고 이미지 합치기 작업을 진행합니다.
                    self.viewModel.timer?.invalidate()
                    self.viewModel.timer = nil
                    self.viewModel.mergedImage = self.viewModel.mergeImages()
                    return
                }
                
                // 좌우 반전된 이미지를 배열에 추가
                      if let flippedImage = image.withHorizontallyFlippedOrientation() {
                          self.viewModel.capturedImages.append(flippedImage)
                      }
                self.viewModel.captureCount += 1
                
                // 4장이 모두 캡처되었으면 이미지 병합
                if self.viewModel.capturedImages.count == 4 {
                    self.viewModel.mergedImage = self.viewModel.mergeImages()
                }
            }
        }

    }
}


// UIImage 확장: 좌우 반전 함수 추가
extension UIImage {
    func withHorizontallyFlippedOrientation() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: .leftMirrored)
    }
}

