//
//  Tag.swift
//  Task
//
//  Created by Роман Мошковцев on 28.06.2021.
//

import Foundation
import SwiftUI

public class TagItem: NSObject, NSSecureCoding{
    public static var supportsSecureCoding: Bool = true
    
    var title: String?
    var style: ButtonsStyle?
    var color: Color?
    
    init(
        title: String,
        style: ButtonsStyle,
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
        style = ButtonsStyle(rawValue: (coder.decodeObject(forKey: "style") as! Int)) ?? .base
        if #available(iOS 15.0, *) {
            color = Color(uiColor: coder.decodeObject(forKey: "color") as! UIColor)
        }
        
        super.init()
    }
}

class Transformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let value = value {
            do{
                return try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
            }
            catch  {
                print(error)
            }
        }
        return nil
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
}

extension Transformer {
    static let name = NSValueTransformerName(rawValue: String(describing: Transformer.self))
    
    public static func register() {
        let transformer = Transformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
