import UIKit

// ImageProcessor: 이미지를 처리하는 클래스
class ImageProcessor {
    // 이미지 두 개 합치기
    func mergeImage(image: UIImage, frameImage:UIImage) -> UIImage? {
        
        // 병합할 이미지의 크기를 프레임 이미지의 크기로 설정
        let size = frameImage.size
        
        // 그래픽 컨텍스트 생성
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // 첫 번째 이미지 (사용자 이미지)를 그리기
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height-350))
        
        // 두 번째 이미지 (프레임 이미지)를 그리기
        frameImage.draw(in: CGRect(x: 0, y: 0, width: size.width + 5, height: size.height))

        // 병합된 이미지 생성
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 그래픽 컨텍스트 종료
        UIGraphicsEndImageContext()

        return mergedImage
    }
}
