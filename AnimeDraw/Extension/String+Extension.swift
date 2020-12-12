//
//  String+Extension.swift
//  AnimeDraw
//
//  Created by haiphan on 12/12/20.
//

import UIKit

extension String {
    func getTextSizeNoteView(fontSize: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options,
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)],
                                                   context: nil)
    }
}
