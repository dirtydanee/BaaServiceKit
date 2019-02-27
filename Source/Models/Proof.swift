public struct Proof {
    
    public let nodeHash: NodeHash
    public let metadata: [String: Any]
    
    class Bar {}
    static var bundle: Bundle { return Bundle(for: Proof.Bar.self) }
    
    static func make(from chainPointProof: ChainpointProofResponse, with nodeHash: NodeHash) -> Proof {
        
        var metadata = [String: Any]()
        
        do {
            let encode = JSONEncoder()
            encode.dataEncodingStrategy = .deferredToData
            encode.keyEncodingStrategy = .convertToSnakeCase
            
            let jsonData = try encode.encode(chainPointProof)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let dict = decoded as? [String: Any] {
                metadata = dict
            }
        } catch {
            print("Proof.make -> json error: \(error)")
        }
        
        let proof = Proof(nodeHash: nodeHash, metadata: metadata)
        return proof
    }
    
    func convert() -> ChainpointProofResponse? {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self.metadata, options: JSONSerialization.WritingOptions.prettyPrinted)
            return try JSONDecoder.chainpoint.decode(ChainpointProofResponse.self, from: data)
        } catch {
            print("Proof.convert -> json error: \(error)")
        }
        
        return nil
    }
}

public class Maker {
    
    public init() {}
    public func makeSample(data: Data, urls: [URL] = [URL(string: "http://35.236.228.81")!]) -> Proof? {
        let nodeHash = NodeHash(hashValue: "1957db7fe23e4be1740ddeb941ddda7ae0a6c482e536a9e00b5aa82db1e84547",
                                hashIdentifier: "f797ea40-daee-11e8-992b-017423dbd52f",
                                urls: urls)
                
        let decodedProof = try! JSONDecoder.chainpoint.decode([ChainpointProofResponse].self, from: data)
        let proof = Proof.make(from: decodedProof.first!, with: nodeHash)
        return proof
        
    }
}


class DictionaryEncoder {
    
    private let encoder = JSONEncoder()
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        set { encoder.dateEncodingStrategy = newValue }
        get { return encoder.dateEncodingStrategy }
    }
    
    var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        set { encoder.dataEncodingStrategy = newValue }
        get { return encoder.dataEncodingStrategy }
    }
    
    var nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy {
        set { encoder.nonConformingFloatEncodingStrategy = newValue }
        get { return encoder.nonConformingFloatEncodingStrategy }
    }
    
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        set { encoder.keyEncodingStrategy = newValue }
        get { return encoder.keyEncodingStrategy }
    }
    
    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
}

class DictionaryDecoder {
    
    private let decoder = JSONDecoder()
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }
    
    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }
    
    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }
    
    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
}
