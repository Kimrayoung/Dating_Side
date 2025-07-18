//
//  MultipartFormBuilder.swift
//  Dating_Side
//
//  Created by 김라영 on 7/18/25.
//

import UIKit

struct MultipartFormDataBuilder {
    private(set) var body = Data()
    private let boundary: String

    init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
    }

    var contentType: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    mutating func appendTextField(named name: String, value: String) {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        body.append("\(value)\r\n")
    }

    // 일반 데이터(String, Int등)
    mutating func appendJSONField<T: Encodable>(named name: String, value: T) {
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(value),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        body.append("Content-Type: application/json\r\n\r\n")
        body.append("\(jsonString)\r\n")
    }

    //Image데이터
    mutating func appendImageField(named name: String, image: UIImage, filename: String = UUID().uuidString + ".jpg", mimeType: String = "image/jpeg", compressionQuality: CGFloat = 0.8) {
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else { return }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
    }

    mutating func finalize() {
        body.append("--\(boundary)--\r\n")
    }

    func build() -> Data {
        return body
    }

    func getBoundary() -> String {
        return boundary
    }
}
