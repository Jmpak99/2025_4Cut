import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreImage.CIFilterBuiltins
import UIKit
import Photos


// ResultViewModel: 결과 화면에서 이미지 처리, QR 코드 생성 및 저장 기능을 담당하는 ViewModel
class ResultViewModel: ObservableObject {
    
    // State 변수: UI 상태를 관리
    @Published var isFirst = true // 처음 상태인지 여부
    @Published var qrCodeImage: UIImage? = nil // 생성된 QR 코드 이미지
    
    // CoreImage 관련 객체 초기화
    let context = CIContext() // CoreImage 처리 컨텍스트
    let filter = CIFilter.qrCodeGenerator() // QR 코드 생성 필터
    
    
    // "다시 찍기" 버튼 클릭 시 호출, 상태를 초기화 (isFirst를 false로 바꿈)
    func retakeProcess() {
        // False
        isFirst = false // 상태를 초기화
    }
    
    // 이미지를 프레임과 합성하는 함수
    func mergeImage(image: UIImage) -> UIImage? {
        isFirst = true // 상태 초기화
        
            // 프레임 이미지를 불러옴
            guard let frameImage = UIImage(named: "4cut_frame") else {
                print("프레임 이미지를 불러올 수 없습니다.")
                return nil
            }
            
            // 원본 이미지와 프레임 이미지의 크기를 기반으로 새로운 이미지 크기 결정
            let newSize = CGSize(width: frameImage.size.width, height: frameImage.size.height)
            
            // 그래픽 컨텍스트 생성
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            
            // 원본 이미지를 합성할 위치 설정
            let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            image.draw(in: imageRect)
            
            // 프레임 이미지를 합성할 위치 설정
            let frameRect = CGRect(x:0, y: 0, width: frameImage.size.width, height: frameImage.size.height)
            frameImage.draw(in: frameRect)
            
            // 최종 합성된 이미지 가져오기
            let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // 그래픽 컨텍스트 종료
            UIGraphicsEndImageContext()
            
            return mergedImage
        }
    
        // Firebase Storage에 이미지를 업로드하고 링크를 기반해서 QR 코드를 생성하는 함수
       func uploadImageAndGenerateQRCode(image: UIImage) {
           // 고유한 파일 이름 생성
           let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
           
           // 이미지 데이터를 압축하여 준비
           guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
           
           // 이미지를 Firebase Storage에 업로드
           storageRef.putData(imageData, metadata: nil) { (metadata, error) in
               guard error == nil else {
                   print("Failed to upload image to Firebase Storage")
                   return
               }
               
               // 업로드된 이미지의 다운로드 URL 가져오기
               storageRef.downloadURL { (url, error) in
                   guard let downloadURL = url else {
                       print("Failed to get download URL")
                       return
                   }
                   // QR 코드 생성
                   self.generateQRCode2(from: downloadURL.absoluteString)
               }
           }
       }
    
    
    
    // QR만들기 두번째 방법
    func generateQRCode2(from string: String) -> UIImage{
        // QR 코드의 데이터 설정
        filter.message = Data(string.utf8)
        
        // QR 코드 이미지 생성
        if let outputImage = filter.outputImage{
            if let cgImage = context.createCGImage(outputImage, from : outputImage.extent)
            {
                self.qrCodeImage = UIImage(cgImage: cgImage) // 상태 업데이트
                return UIImage(cgImage: cgImage)
            }
        }
        // 기본 이미지 변환 (실패 시)
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
    
    // 이미지 앨범에 저장
    func saveImageToAlbum(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        // 사진 앨범 접근 권한 요청
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                // 접근 권한이 없을 경우 에러 반환
                completion(false, NSError(domain: "PhotoLibraryAccessDenied", code: 1, userInfo: nil))
                return
            }
            
            // 사진 저장 작업 수행
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image) // 앨범에 이미지 저장
            }) { success, error in
                // 결과를 메인 스레드로 전달
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        }
    }
}
