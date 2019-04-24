//
//  UIImage+MTExt.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.

import UIKit
import ImageIO
import MobileCoreServices
import Accelerate

// MARK: - Initializers
public extension UIImage {
    
    /// Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
}

// MARK: - Properties
public extension UIImage {
    
    /// Size in bytes of UIImage
    var bytesSize: Int {
        return self.jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// Size in kilo bytes of UIImage
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
}

public extension UIImage {

    /// - Parameter color
    /// - Returns
	static func image(withColor color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()

		context?.setFillColor(color.cgColor)
		context?.fill(rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}
    
    /// UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    ///
    /// - Parameter color
    /// - Returns:  A 1x1 UIImage of a solid color.
    static func pixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(pixel.size)
        defer { UIGraphicsEndImageContext() }
        
        #if swift(>=2.3)
            guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        #else
            let context = UIGraphicsGetCurrentContext()
        #endif
        
        context.setFillColor(color.cgColor)
        context.fill(pixel)
        
        #if swift(>=2.3)
            return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        #else
            return UIGraphicsGetImageFromCurrentImageContext()
        #endif
    }

}

public extension UIImage {
    
    ///
    /// - Returns
	func largestCenteredSquareImage() -> UIImage {
		let scale = self.scale

		let originalWidth = self.size.width * scale
		let originalHeight = self.size.height * scale

		let edge: CGFloat
		if originalWidth > originalHeight {
			edge = originalHeight
		} else {
			edge = originalWidth
		}

		let posX = (originalWidth - edge) / 2.0
		let posY = (originalHeight - edge) / 2.0

		let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)

		let imageRef = self.cgImage?.cropping(to: cropSquare)!

		return UIImage(cgImage: imageRef!, scale: scale, orientation: self.imageOrientation)
	}
    
    ///
    /// - Parameter targetSize
    /// - Returns: image
	func resizeTo(_ targetSize: CGSize) -> UIImage {
		let size = self.size

		let widthRatio = targetSize.width / self.size.width
		let heightRatio = targetSize.height / self.size.height

		let scale = UIScreen.main.scale
		let newSize: CGSize
		if (widthRatio > heightRatio) {
			newSize = CGSize(width: scale * floor(size.width * heightRatio), height: scale * floor(size.height * heightRatio))
		} else {
			newSize = CGSize(width: scale * floor(size.width * widthRatio), height: scale * floor(size.height * widthRatio))
		}

		let rect = CGRect(x: 0, y: 0, width: floor(newSize.width), height: floor(newSize.height))

		// println("size: \(size), newSize: \(newSize), rect: \(rect)")

		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage!
	}
    
    /// UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width < size.width && rect.size.height < size.height else { return self }
        guard let image: CGImage = cgImage?.cropping(to: rect) else { return self }
        return UIImage(cgImage: image)
    }


    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///
    /// - Parameter sideLength
    /// - Returns
	func scaleToMinSideLength(_ sideLength: CGFloat) -> UIImage {

		let pixelSideLength = sideLength * UIScreen.main.scale

		// println("pixelSideLength: \(pixelSideLength)")
		// println("size: \(size)")

		let pixelWidth = size.width * scale
		let pixelHeight = size.height * scale

		// println("pixelWidth: \(pixelWidth)")
		// println("pixelHeight: \(pixelHeight)")

		let newSize: CGSize

		if pixelWidth > pixelHeight {

			guard pixelHeight > pixelSideLength else {
				return self
			}

			let newHeight = pixelSideLength
			let newWidth = (pixelSideLength / pixelHeight) * pixelWidth
			newSize = CGSize(width: floor(newWidth), height: floor(newHeight))

		} else {

			guard pixelWidth > pixelSideLength else {
				return self
			}

			let newWidth = pixelSideLength
			let newHeight = (pixelSideLength / pixelWidth) * pixelHeight
			newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
		}

		if scale == UIScreen.main.scale {
			let newSize = CGSize(width: floor(newSize.width / scale), height: floor(newSize.height / scale))
			// println("A scaleToMinSideLength newSize: \(newSize)")

			UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
			let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
			self.draw(in: rect)
			let newImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

			if let image = newImage {
				return image
			}

			return self

		} else {
			// println("B scaleToMinSideLength newSize: \(newSize)")
			UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
			let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
			self.draw(in: rect)
			let newImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

			if let image = newImage {
				return image
			}

			return self
		}
	}
    
    /// Adjusts the orientation of the image from the capture orientation.
    ///      This is an issue when taking images, the capture orientation is not set correctly when using Portrait.
    ///
    /// - Returns: An optional UIImage if successful.
	func adjustOrientation() -> UIImage? {
		if self.imageOrientation == .up {
			return self
		}

		let width = self.size.width
		let height = self.size.height

		var transform = CGAffineTransform.identity

		switch self.imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: width, y: height)
			transform = transform.rotated(by: CGFloat(Double.pi))

		case .left, .leftMirrored:
			transform = transform.translatedBy(x: width, y: 0)
			transform = transform.rotated(by: CGFloat(Double.pi / 2))

		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: height)
			transform = transform.rotated(by: CGFloat(-Double.pi / 2))

		default:
			break
		}

		switch self.imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		default:
			break
		}

		let selfCGImage = self.cgImage
        
        // Draw the underlying cgImage with the calculated transform.
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0, space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue) else {
            return nil
        }

		context.concatenate(transform)

		switch self.imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			context.draw(selfCGImage!, in: CGRect(x: 0, y: 0, width: height, height: width))

		default:
			context.draw(selfCGImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
		}
        
        guard let cgImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)

	}
}


public extension UIImage {

    ///
    /// - Parameter aspectRatio
    /// - Returns
	func cropToAspectRatio(_ aspectRatio: CGFloat) -> UIImage {
		let size = self.size

		let originalAspectRatio = size.width / size.height

		var rect = CGRect.zero

		if originalAspectRatio > aspectRatio {
			let width = size.height * aspectRatio
			rect = CGRect(x: (size.width - width) * 0.5, y: 0, width: width, height: size.height)

		} else if originalAspectRatio < aspectRatio {
			let height = size.width / aspectRatio
			rect = CGRect(x: 0, y: (size.height - height) * 0.5, width: size.width, height: height)

		} else {
			return self
		}

		let cgImage = self.cgImage?.cropping(to: rect)!
		return UIImage(cgImage: cgImage!)
	}
}

public extension UIImage {
    

    ///
    /// - Parameter tintColor
    /// - Returns:
	func imageWithGradientTintColor(_ tintColor: UIColor) -> UIImage {

		return imageWithTintColor(tintColor, blendMode: CGBlendMode.overlay)
	}


    ///
    /// - Parameters:
    ///   - tintColor
    ///   - blendMode
    /// - Returns
	func imageWithTintColor(_ tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)

		tintColor.setFill()

		let bounds = CGRect(origin: CGPoint.zero, size: size)

		UIRectFill(bounds)

		self.draw(in: bounds, blendMode: blendMode, alpha: 1)

		if blendMode != CGBlendMode.destinationIn {
			self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1)
		}

		let tintedImage = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()

		return tintedImage!
	}
}

public extension UIImage {

    
    ///
    /// - Parameter size
    /// - Returns
	func renderAtSize(_ size: CGSize) -> UIImage {

		let size = CGSize(width: ceil(size.width), height: ceil(size.height))

		UIGraphicsBeginImageContextWithOptions(size, false, 0) // key

		let context = UIGraphicsGetCurrentContext()

		draw(in: CGRect(origin: CGPoint.zero, size: size))

		let cgImage = context?.makeImage()!

		let image = UIImage(cgImage: cgImage!)

		UIGraphicsEndImageContext()

		return image
	}
}



public extension UIImage {
    // MARK: - Decode

    
    ///
    ///
    /// - Returns: the decoded image
	func decoded() -> UIImage {
		return decodedWith( scale)
	}

    
    /// decode image
    ///
    /// - Parameter scale: scale
    /// - Returns: the decoded image
	func decodedWith(_ scale: CGFloat) -> UIImage {
		let imageRef = cgImage
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let context = CGContext(data: nil, width: (imageRef?.width)!, height: (imageRef?.height)!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

		if let context = context {
			let rect = CGRect(x: 0, y: 0, width: CGFloat((imageRef?.width)!), height: CGFloat((imageRef?.height)!))
			context.draw(imageRef!, in: rect)
			let decompressedImageRef = context.makeImage()!

			return UIImage(cgImage: decompressedImageRef, scale: scale, orientation: imageOrientation) 
		}

		return self
	}
}



public extension UIImage {
    // MARK: Resize
    
    

	func resizeTo(_ size: CGSize, withTransform transform: CGAffineTransform, drawTransposed: Bool, interpolationQuality: CGInterpolationQuality) -> UIImage? {

		let newRect = CGRect(origin: CGPoint.zero, size: size).integral
		let transposedRect = CGRect(origin: CGPoint.zero, size: CGSize(width: size.height, height: size.width))

		let bitmapContext = CGContext(data: nil, width: Int(newRect.width), height: Int(newRect.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace!)!, bitmapInfo: (cgImage?.bitmapInfo.rawValue)!)

		bitmapContext?.concatenate(transform)

		bitmapContext!.interpolationQuality = interpolationQuality

		bitmapContext?.draw(cgImage!, in: drawTransposed ? transposedRect : newRect)

		let newCGImage = bitmapContext?.makeImage()!
		let newImage = UIImage(cgImage: newCGImage!)

		return newImage
	}


	func transformForOrientation(_ size: CGSize) -> CGAffineTransform {
		var transform = CGAffineTransform.identity

		switch imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: size.height)
			transform = transform.rotated(by: CGFloat(Double.pi))

		case .left, .leftMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.rotated(by: CGFloat(Double.pi / 2))

		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: size.height)
			transform = transform.rotated(by: CGFloat(-Double.pi / 2))

		default:
			break
		}

		switch imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: size.height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		default:
			break
		}

		return transform
	}


	func resizeTo(_ size: CGSize, withInterpolationQuality interpolationQuality: CGInterpolationQuality) -> UIImage? {

		let drawTransposed: Bool

		switch imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			drawTransposed = true
		default:
			drawTransposed = false
		}

		return resizeTo(size, withTransform: transformForOrientation(size), drawTransposed: drawTransposed, interpolationQuality: interpolationQuality)
	}
    
    /// 给图片加上圆角
    ///
    /// - Parameter cornerRadius: 圆角弧度
    /// - Returns: 结果图片
    final func imageByRoundingCornersTo(_ cornerRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: cornerRadius, bottom: 0, right: cornerRadius))
    }
    
    
    /// UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

public extension UIImage {

	var mt_avarageColor: UIColor {

		let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
		let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)!

		context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))

		let alpha: CGFloat = (rgba[3] > 0) ? (CGFloat(rgba[3]) / 255.0) : 1
		let multiplier = alpha / 255.0

		return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
	}

    func color(at point: CGPoint) -> UIColor {
        guard let pixelData = self.cgImage?.dataProvider?.data else {
            return UIColor.clear
        }
        let data = CFDataGetBytePtr(pixelData)
        let x = Int(point.x)
        let y = Int(point.y)
        let index = Int(self.size.width) * y + x
        let expectedLengthA = Int(self.size.width * self.size.height)
        let expectedLengthRGB = 3 * expectedLengthA
        let expectedLengthRGBA = 4 * expectedLengthA
        let numBytes = CFDataGetLength(pixelData)
        switch numBytes {
        case expectedLengthA:
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data![index])/255.0)
        case expectedLengthRGB:
            return UIColor(red: CGFloat(data![3*index])/255.0, green: CGFloat(data![3*index+1])/255.0, blue: CGFloat(data![3*index+2])/255.0, alpha: 1.0)
        case expectedLengthRGBA:
            return UIColor(red: CGFloat(data![4*index])/255.0, green: CGFloat(data![4*index+1])/255.0, blue: CGFloat(data![4*index+2])/255.0, alpha: CGFloat(data![4*index+3])/255.0)
        default:
            // unsupported format
            return UIColor.clear
        }
    }
    
//    func color(at point: CGPoint) -> UIColor? {
//        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        guard let imgRef = cgImage,
//            let dataProvider = imgRef.dataProvider,
//            let dataCopy = dataProvider.data,
//            let data = CFDataGetBytePtr(dataCopy),
//            rect.contains(point) else {
//                return nil
//        }
//        
//        let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
//        let red = CGFloat(data[pixelInfo]) / 255.0
//        let green = CGFloat(data[pixelInfo + 1]) / 255.0
//        let blue = CGFloat(data[pixelInfo + 2]) / 255.0
//        let alpha = CGFloat(data[pixelInfo + 3]) / 255.0
//        
//        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
//    }
    
    
    func color(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
        let size = self.size
        let cgImage = self.cgImage
        
        DispatchQueue.global(qos: .userInteractive).async {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let imgRef = cgImage,
                let dataProvider = imgRef.dataProvider,
                let dataCopy = dataProvider.data,
                let data = CFDataGetBytePtr(dataCopy),
                rect.contains(point) else {
                    completion(nil)
                    return
            }
            
            let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
            let red = CGFloat(data[pixelInfo]) / 255.0
            let green = CGFloat(data[pixelInfo + 1]) / 255.0
            let blue = CGFloat(data[pixelInfo + 2]) / 255.0
            let alpha = CGFloat(data[pixelInfo + 3]) / 255.0
            
            DispatchQueue.main.async {
                completion(UIColor(red: red, green: green, blue: blue, alpha: alpha))
            }
        }
    }
    
}



public extension UIImage {
    // MARK: Progressive
    
	var mt_progressiveImage: UIImage? {

		guard let cgImage = cgImage else {
			return nil
		}

		let data = NSMutableData()

		guard let distination = CGImageDestinationCreateWithData(data, kUTTypeJPEG, 1, nil) else {
			return nil
		}

		let jfifProperties = [
            kCGImagePropertyJFIFIsProgressive as String: kCFBooleanTrue as! Bool,
			kCGImagePropertyJFIFXDensity as String: 72,
			kCGImagePropertyJFIFYDensity as String: 72,
			kCGImagePropertyJFIFDensityUnit as String: 1,
		] as [String : Any]

		let properties = [
			kCGImageDestinationLossyCompressionQuality as String: 0.9,
			kCGImagePropertyJFIFDictionary as String: jfifProperties,
		] as [String : Any]

		CGImageDestinationAddImage(distination, cgImage, properties as CFDictionary?)

		guard CGImageDestinationFinalize(distination) else {
			return nil
		}

		guard data.length > 0 else {
			return nil
		}

		guard let progressiveImage = UIImage(data: data as Data) else {
			return nil
		}

		return progressiveImage
	}

}


public extension UIImage {
    // MARK: - averageColor  mergedColor

    
    /// 获取图片平均颜色
    final var averageColor: UIColor? {
        #if swift(>=3.0)
            guard let cgImage = cgImage else { return nil }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let alphaInfo: CGImageAlphaInfo = .premultipliedLast
            let bitmapInfo: CGBitmapInfo = [CGBitmapInfo(rawValue: alphaInfo.rawValue), .byteOrder32Big]
        #else
            guard let cgImage = CGImage else { return nil }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let alphaInfo: CGImageAlphaInfo = .PremultipliedLast
            let bitmapInfo: CGBitmapInfo = [CGBitmapInfo(rawValue: alphaInfo.rawValue), .ByteOrder32Big]
        #endif
        #if swift(>=3)
            guard let context = CGContext(data: nil, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
                else { return nil }
        #elseif swift(>=2.2) && !swift(>=3)
            let context = CGBitmapContextCreate(nil, 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)
        #else
            let context = CGBitmapContextCreate(UnsafeMutablePointer<UInt8>(), 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)
        #endif
        #if swift(>=3)
            context .draw(cgImage, in: CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1)))
        #else
            CGContextDrawImage(context, CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1)), cgImage)
        #endif
        
        #if swift(>=3)
            guard let data = context.data else { return nil }
            let rgba = data.assumingMemoryBound(to: UInt8.self)
        #else
            let data = CGBitmapContextGetData(context)
            let rgba = UnsafePointer<UInt8>(data)
        #endif
        
        let color: UIColor
        if rgba[3] > 0 {
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            color = UIColor(
                red: CGFloat(rgba[0]) * multiplier,
                green: CGFloat(rgba[1]) * multiplier,
                blue: CGFloat(rgba[2]) * multiplier,
                alpha: alpha
            )
        } else {
            color = UIColor(
                red: CGFloat(rgba[0]) / 255.0,
                green: CGFloat(rgba[1]) / 255.0,
                blue: CGFloat(rgba[2]) / 255.0,
                alpha: CGFloat(rgba[3]) / 255.0
            )
        }
        return color
    }


    /// 获取合并的色彩组合 Draws the image onto a rect of {0, 0, 1, 1} and returns the resulting color mix.
    final var mergedColor: UIColor? {
        #if swift(>=3)
            let size = CGSize(width: 1, height: 1)
            if #available(iOS 10, *) {
                let renderer = UIGraphicsImageRenderer(size: size)
                let rgba = renderer.pngData(actions: { (context) in
                    context.cgContext.interpolationQuality = .medium
                    draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
                })
                return UIColor(
                    red: CGFloat(rgba[0]) / 255.0,
                    green: CGFloat(rgba[1]) / 255.0,
                    blue: CGFloat(rgba[2]) / 255.0,
                    alpha: CGFloat(rgba[3]) / 255.0
                )
            } else {
                UIGraphicsBeginImageContext(size)
                defer { UIGraphicsEndImageContext() }
                guard let context = UIGraphicsGetCurrentContext() else { return nil }
                context.interpolationQuality = .medium
                draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
                guard let data = context.data else { return nil }
                let rgba = data.assumingMemoryBound(to: UInt8.self)
                return UIColor(
                    red: CGFloat(rgba[0]) / 255.0,
                    green: CGFloat(rgba[1]) / 255.0,
                    blue: CGFloat(rgba[2]) / 255.0,
                    alpha: CGFloat(rgba[3]) / 255.0
                )
            }
        #else
            let size = CGSize(width: 1, height: 1)
            UIGraphicsBeginImageContext(size)
            defer { UIGraphicsEndImageContext() }
            let context = UIGraphicsGetCurrentContext()
            CGContextSetInterpolationQuality(context, .Medium)
            drawInRect(CGRect(origin: CGPoint.zero, size: size), blendMode: .Copy, alpha: 1.0)
            let data = CGBitmapContextGetData(context)
            let rgba = UnsafePointer<UInt8>(data)
            return UIColor(
            red: CGFloat(rgba[0]) / 255.0,
            green: CGFloat(rgba[1]) / 255.0,
            blue: CGFloat(rgba[2]) / 255.0,
            alpha: CGFloat(rgba[3]) / 255.0
            )
        #endif
    }
    
}


class CountedColor {
    let color: UIColor
    let count: Int
    
    init(color: UIColor, count: Int) {
        self.color = color
        self.count = count
    }
}

public extension UIImage {
    
    fileprivate func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
    

    func colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        let cgImage: CGImage
        
        if let scaleDownSize = scaleDownSize {
            cgImage = resize(to: scaleDownSize).cgImage!
        } else {
            let ratio = size.width / size.height
            let r_width: CGFloat = 250
            cgImage = resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        let randomColorsThreshold = Int(CGFloat(height) * 0.01)
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let data = UnsafePointer<UInt8>(context?.data?.assumingMemoryBound(to: UInt8.self))
        let imageBackgroundColors = NSCountedSet(capacity: height)
        let imageColors = NSCountedSet(capacity: width * height)
        
        let sortComparator: (CountedColor, CountedColor) -> Bool = { (a, b) -> Bool in
            return a.count <= b.count
        }
        
        for x in 0..<width {
            for y in 0..<height {
                let pixel = ((width * y) + x) * bytesPerPixel
                let color = UIColor(
                    red:   CGFloat((data?[pixel+1])!) / 255,
                    green: CGFloat((data?[pixel+2])!) / 255,
                    blue:  CGFloat((data?[pixel+3])!) / 255,
                    alpha: 1
                )
                
                if x >= 5 && x <= 10 {
                    imageBackgroundColors.add(color)
                }
                
                imageColors.add(color)
            }
        }
        
        var sortedColors = [CountedColor]()
        
        for color in imageBackgroundColors {
            guard let color = color as? UIColor else { continue }
            
            let colorCount = imageBackgroundColors.count(for: color)
            
            if randomColorsThreshold <= colorCount  {
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }
        
        sortedColors.sort(by: sortComparator)
        
        var proposedEdgeColor = CountedColor(color: blackColor, count: 1)
        
        if let first = sortedColors.first { proposedEdgeColor = first }
        
        if proposedEdgeColor.color.isBlackOrWhite && !sortedColors.isEmpty {
            for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
                if !countedColor.color.isBlackOrWhite {
                    proposedEdgeColor = countedColor
                    break
                }
            }
        }
        
        let imageBackgroundColor = proposedEdgeColor.color
        let isDarkBackgound = imageBackgroundColor.isDark
        
        sortedColors.removeAll()
        
        for imageColor in imageColors {
            guard let imageColor = imageColor as? UIColor else { continue }
            
            let color = imageColor.color(minSaturation: 0.15)
            
            if color.isDark == !isDarkBackgound {
                let colorCount = imageColors.count(for: color)
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }
        
        sortedColors.sort(by: sortComparator)
        
        var primaryColor, secondaryColor, detailColor: UIColor?
        
        for countedColor in sortedColors {
            let color = countedColor.color
            
            if primaryColor == nil &&
                color.isContrasting(with: imageBackgroundColor) {
                primaryColor = color
            } else if secondaryColor == nil &&
                primaryColor != nil &&
                primaryColor!.isDistinct(from: color) &&
                color.isContrasting(with: imageBackgroundColor) {
                secondaryColor = color
            } else if secondaryColor != nil &&
                (secondaryColor!.isDistinct(from: color) &&
                    primaryColor!.isDistinct(from: color) &&
                    color.isContrasting(with: imageBackgroundColor)) {
                detailColor = color
                break
            }
        }
        
        free(raw)
        
        return (
            imageBackgroundColor,
            primaryColor   ?? (isDarkBackgound ? whiteColor : blackColor),
            secondaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
            detailColor    ?? (isDarkBackgound ? whiteColor : blackColor))
    }
    

}



extension UIImage {
    func applyLightEffect() -> UIImage? {
        return applyBlurWithRadius(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }
    
    func applyExtraLightEffect() -> UIImage? {
        return applyBlurWithRadius(20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }
    
    func applyDarkEffect() -> UIImage? {
        return applyBlurWithRadius(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }
    
    func applyTintEffectWithColor(_ tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        
        let componentCount = tintColor.cgColor.numberOfComponents
        
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        
        return applyBlurWithRadius(10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    func applyBlurWithRadius(_ blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if (size.width < 1 || size.height < 1) {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        guard let cgImage = self.cgImage else {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if maskImage != nil && maskImage!.cgImage == nil {
            print("*** error: maskImage must be backed by a CGImage: \(String(describing: maskImage))")
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat(Float.ulpOfOne)
        let screenScale = UIScreen.main.scale
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            guard let effectInContext = UIGraphicsGetCurrentContext() else { return  nil }
            
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(cgImage, in: imageRect)
            
            var effectInBuffer = createEffectBuffer(effectInContext)
            
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            
            guard let effectOutContext = UIGraphicsGetCurrentContext() else { return  nil }
            var effectOutBuffer = createEffectBuffer(effectOutContext)
            
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                let inputRadius = blurRadius * screenScale
                let d = floor(inputRadius * 3.0 * CGFloat(sqrt(2 * Double.pi) / 4 + 0.5))
                var radius = UInt32(d)
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        
        guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }
        
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext.draw(cgImage, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext.saveGState()
            if let maskCGImage = maskImage?.cgImage {
                outputContext.clip(to: imageRect, mask: maskCGImage);
            }
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(color.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
