//
//  TCPickerViewThemeType.swift
//  Pods-TCPickerViewExample
//
//  Created by Taras Chernyshenko on 6/13/18.
//

import UIKit

public protocol TCPickerViewThemeType {
    var doneText: String { get }
    var closeText: String { get }
    
    var backgroundColor: UIColor { get }
    var titleColor: UIColor { get }
    var doneTextColor: UIColor { get }
    var closeTextColor: UIColor { get }
    var headerBackgroundColor: UIColor { get }
    var doneBackgroundColor: UIColor { get }
    var closeBackgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    
    var buttonsFont: UIFont { get }
    var titleFont: UIFont { get }
    
    var rowHeight: CGFloat { get }
    var headerHeight: CGFloat { get }
    var cornerRadius: CGFloat { get }
    
    init()
}

public final class TCPickerViewDefaultTheme: TCPickerViewThemeType {
    public required init() {}
}

extension TCPickerViewThemeType {
    public var doneText: String {
        return "Done"
    }
    
    public var closeText: String {
        return "Cancel"
    }
    
    public var backgroundColor: UIColor {
        return UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
    }
    
    public var titleColor: UIColor {
        return .white
    }
    
    public var doneTextColor: UIColor {
        return .white
    }
    
    public var closeTextColor: UIColor {
        return .white
    }
    
    public var headerBackgroundColor: UIColor {
        return UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
    }
    
    public var doneBackgroundColor: UIColor {
        return UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
    }
    
    public var closeBackgroundColor: UIColor {
        return UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
    }
    
    public var separatorColor: UIColor {
        return .darkGray
    }
    
    public var buttonsFont: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    
    public var titleFont: UIFont{
        return UIFont.boldSystemFont(ofSize: 13.5)
    }
    
    public var rowHeight: CGFloat {
        return 35
    }
    
    public var headerHeight: CGFloat {
        return 60
    }
    
    public var cornerRadius: CGFloat {
        return 15.0
    }
    
}
