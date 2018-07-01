final class NodeHashValueTransformer: ValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let urls = value as? [URL] else {
            assertionFailure("Invalid type of value in \(type(of: self))")
            return nil
        }

        return NSKeyedArchiver.archivedData(withRootObject: urls)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let urlsData = value as? Data else {
            assertionFailure("Invalid type of archived value in \(type(of: self))")
            return nil
        }

        return NSKeyedUnarchiver.unarchiveObject(with: urlsData) as? [URL]
    }
}
