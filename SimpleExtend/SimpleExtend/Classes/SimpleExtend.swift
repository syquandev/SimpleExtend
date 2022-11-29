
import UIKit

public class SimpleExtend: NSObject {
    
    public static let shared = SimpleExtend()
    
    
    
    public static func getBundle() -> Bundle? {
        let frameworkBundle = Bundle(for: SimpleExtend.self)
        let path = frameworkBundle.resourceURL?.appendingPathComponent("SimpleExtend.bundle")
        let resourcesBundle = Bundle(url: path!)
        return resourcesBundle
        
    }
    
    public static func resourcesPath(name: String, type: String) -> String? {
        let bundle = SimpleExtend.getBundle()
        let pathForResourceString = bundle?.path(forResource: name, ofType: type)
        return pathForResourceString
    }
    
}
