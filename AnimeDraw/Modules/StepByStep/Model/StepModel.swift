//
//  StepModel.swift
//  AnimeDraw
//
//  Created by haiphan on 12/11/20.
//

struct StepModel: Codable {
    let image, text: String?
    enum CodingKeys: String, CodingKey {
        case image
        case text
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }
}
