//
//  Tag.swift
//  Task
//
//  Created by Роман Мошковцев on 28.06.2021.
//

import Foundation
import SwiftUI

public class TagItem: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    var title: String?
    var style: TagsStyle?
    var color: Color?
    
    init(
        title: String,
        style: TagsStyle,
        color: Color
    ){
        self.title = title
        self.style = style
        self.color = color
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(style?.rawValue, forKey: "style")
        coder.encode(UIColor(color ?? .clear), forKey: "color")
    }
    
    public required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String ?? ""
        style = TagsStyle(rawValue: (coder.decodeObject(forKey: "style") as! Int)) ?? .base
        color = Color(coder.decodeObject(forKey: "color") as! UIColor)
        
        super.init()
    }
}
