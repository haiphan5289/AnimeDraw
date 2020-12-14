//
//  DisplayTutorialModel.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

struct DisplayTutorialModel: Codable {
    let image: String?
    let width: Int?
    let height: Int?
    let text: String?
    enum CodingKeys: String, CodingKey {
        case image
        case width
        case height
        case text
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
    }
}
