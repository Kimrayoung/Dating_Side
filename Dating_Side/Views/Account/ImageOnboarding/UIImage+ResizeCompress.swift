import UIKit

extension UIImage {
    /// 지정한 너비로 비율에 맞추어 리사이즈하는 함수
    func resize(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: width, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// JPEG 압축 데이터를 생성하는 함수. (0.0 ~ 1.0)
    func compressedJPEGData(quality: CGFloat = 0.7) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
    
    /// 리사이즈 후 압축된 JPEG Data 생성 (체인 활용)
    func resizedAndCompressedJPEGData(toWidth width: CGFloat, quality: CGFloat = 0.7) -> Data? {
        let resized = self.resize(toWidth: width) ?? self
        return resized.compressedJPEGData(quality: quality)
    }
}
