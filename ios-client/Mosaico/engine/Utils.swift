import UIKit
import ARKit
import SwiftyBeaver

/// Instantiate a view controller and return it.
/// The compiler deduces the type of T from the value in which the result is
/// put into.
///
/// https://stackoverflow.com/a/30788735/1584340
func instVC<T>(withIdentifier i: String, storyBoard sb: UIStoryboard) -> T? {
  let vc =
    sb.instantiateViewController(withIdentifier: i)
      as? T
  if (vc == nil) {
    log.error("Failed to inst view with identifier \(i)")
    return nil
  }
  
  return vc
}

func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
  return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
}

let burntOrange = UIColor(red: 0xF5, green: 0x5D, blue: 0x3E)
let palatinatePurple = UIColor(red: 0x68, green: 0x2D, blue: 0x63)
let tealBlue = UIColor(red: 0x38, green: 0x86, blue: 0x97)
let zeroColor = UIColor(red: 0x00, green: 0x00, blue: 0x00).withAlphaComponent(CGFloat(0.0))
let babyPowder = UIColor(red: 0xFE, green: 0xFC, blue: 0xFB)
let persianGreen = UIColor(red: 0x00, green: 0xA6, blue: 0xA6)
let ghostWhite = UIColor(red: 0xF8, green: 0xF7, blue: 0xFF)
let periwinkle = UIColor(red: 0xB8, green: 0xB8, blue: 0xFF)
let cgBlue = UIColor(red: 0x12, green: 0x82, blue: 0xA2)
let platinum = UIColor(red: 0xE6, green: 0xEB, blue: 0xE0)
let prussianBlue = UIColor(red: 0x00, green: 0x30, blue: 0x49)
let oxfordBlue = UIColor(red: 0x00, green: 0x1F, blue: 0x54)

func delay(time: Double, callback: @escaping () -> ()) {
  DispatchQueue.main.asyncAfter(deadline: .now() + time) {
    callback()
  }
}
