// TODO: - Write tests
struct ChainpointProofResponse: Decodable {
    
    struct Proof: Decodable {
        
        struct Branch: Decodable {
            
            // TODO: Discuss how to parse ops variable, is it needed at all?
            let label: String
            
            enum CodingKeys: String, CodingKey {
                case label = "label"
            }
        }
        
        let context: URL
        let type: String
        let hash: String
        let hashIdNode: String
        let hashSubmittedNodeAt: String // Date
        let hashIdCore: String
        let hashSubmittedCoreAt: String // Date
        let branches: [ChainpointProofResponse.Proof.Branch]
        
        enum CodingKeys: String, CodingKey {
            case context = "@context"
            case type = "type"
            case hash = "hash"
            case hashIdNode = "hash_id_node"
            case hashSubmittedNodeAt = "hash_submitted_node_at"
            case hashIdCore = "hash_id_core"
            case hashSubmittedCoreAt = "hash_submitted_core_at"
            case branches = "branches"
        }
    }
    
    let hashIdNode: String
    let proof: ChainpointProofResponse.Proof?
    let anchorsComplete: [String]

    enum CodingKeys: String, CodingKey {
        case hashIdNode = "hash_id_node"
        case proof = "proof"
        case anchorsComplete = "anchors_complete"
    }
}
