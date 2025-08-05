import UIKit

func createUploadBody<T: Encodable>(
    request: T,
    images: [AccountImage],
    boundary: String
) -> Data {
    var body = Data()
    let crlf = "\r\n"

    // 1) JSON 파트
    let encoder = JSONEncoder()
    guard let jsonData = try? encoder.encode(request),
          let jsonString = String(data: jsonData, encoding: .utf8)
    else { return Data() }
    
    // ── curl 예제와 동일하게, name="request" 만 있고 Content-Type 은 생략 ──
    body.appendString("--\(boundary)\(crlf)")
    body.appendString("Content-Disposition: form-data; name=\"request\"\(crlf)\(crlf)")
    body.appendString(jsonString)
    body.appendString(crlf)
    let bodyChecking = String(data: body, encoding: .utf8)
    print(#fileID, #function, #line, "- bodyChecking: \(bodyChecking)")

    // 2) 이미지 파트
    for imageInfo in images {
        // 1) JPEG 압축 데이터로 변환 (예: 0.7 품질)
        guard let imageData = imageInfo.image.jpegData(compressionQuality: 0.7) else { continue }
        let filename = "\(imageInfo.imageTitle).jpg"

        body.appendString("--\(boundary)\(crlf)")
        body.appendString(
          "Content-Disposition: form-data; name=\"\(imageInfo.imageTitle)\"; filename=\"\(filename)\"\(crlf)"
        )
        body.appendString("Content-Type: image/jpeg\(crlf)\(crlf)")
        body.append(imageData)
        body.appendString(crlf)
    }

    // 3) 종료 바운더리
    body.appendString("--\(boundary)--\(crlf)")
    print("— body size: \(body.count) bytes —")
    if let s = String(data: body, encoding: .utf8) {
      print(s)            // 텍스트 파트(헤더 + JSON 부분) 확인
    } else {
      print(body.prefix(200) as NSData)  // 바이너리 앞부분 헥사 덤프
    }
    return body
}

extension Data {
    mutating func appendString(_ string: String) {
        if let d = string.data(using: .utf8) {
            append(d)
        }
    }
}
