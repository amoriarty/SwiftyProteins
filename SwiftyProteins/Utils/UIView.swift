//
//  UIView.swift
//  SwiftyProteins
//
//  Created by Émilie Legent on 20/03/2018.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit

extension UIView {
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
