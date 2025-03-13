import Foundation

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static let once: Void = {
        object_setClass(Bundle.main, AnyLanguageBundle.self)
    }()
    
    static func setLanguage(_ language: String) {
        Bundle.once
        
        let isLanguageRTL = Locale.characterDirection(forLanguage: language) == .rightToLeft
        
        if let languageBundlePath = Bundle.main.path(forResource: language, ofType: "lproj") {
            objc_setAssociatedObject(Bundle.main, &bundleKey, languageBundlePath, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else if let languageBundlePath = Bundle.main.path(forResource: "Base", ofType: "lproj") {
            objc_setAssociatedObject(Bundle.main, &bundleKey, languageBundlePath, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTextDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
} 