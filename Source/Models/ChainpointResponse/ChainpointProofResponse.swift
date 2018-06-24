import Foundation

// TODO: - Write tests
struct ChainpointProofResponse: Codable {
    
    struct Proof: Codable {
        
        struct Branch: Codable {
            let label: String
//            let ops: [String: Any]
            
            enum CodingKeys: String, CodingKey {
                case label = "label"
//                case ops = "ops"
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
    
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let hashIdNode = try container.decode(String.self, forKey: .hashIdNode)
//        let proof = try container.decode(ChainpointProofResponse.Proof.self, forKey: .proof)
//        let anchorsComplete = try container.decode([String].self, forKey: .anchorsComplete)
//        
//        self.init(hashIdNode: hashIdNode, proof: proof, anchorsComplete: anchorsComplete)
//    }
}

// Examples
// 1. None
//[
//    {
//        "hash_id_node": "1957db7fe23e4be1740ddeb941ddda7ae0a6b782e536a9e00b5aa82db1e84547",
//        "proof": {},
//        "anchors_complete": [
//        "cal"
//        ]
//    }
//]

// error
//{
//    "code": "InvalidArgument",
//    "message": "invalid request, bad hash_id"
//}

// ??
//[
//    {
//        "hash_id_node": "a4b52f60-7322-11e8-876e-0159403461ed",
//        "proof": null,
//        "anchors_complete": []
//    }
//]

// 2. Partial
//[
//    {
//        "hash_id_node": "a4b52f60-7322-11e8-876e-0159403461ed",
//        "proof": {
//            "@context": "https://w3id.org/chainpoint/v3",
//            "type": "Chainpoint",
//            "hash": "1957db7fe23e4be1740ddeb941ddda7ae0a6b782e636a9e00b5aa82db1e84547",
//            "hash_id_node": "a4b52f60-7322-11e8-876e-0159403461ed",
//            "hash_submitted_node_at": "2018-06-18T18:08:46Z",
//            "hash_id_core": "a73c4f70-7322-11e8-b7ce-019b42e3a86a",
//            "hash_submitted_core_at": "2018-06-18T18:08:50Z",
//            "branches": [
//            {
//            "label": "cal_anchor_branch",
//            "ops": [
//            {
//            "l": "node_id:a4b52f60-7322-11e8-876e-0159403461ed"
//            },
//            {
//            "op": "sha-256"
//            },
//            {
//            "l": "core_id:a73c4f70-7322-11e8-b7ce-019b42e3a86a"
//            },
//            {
//            "op": "sha-256"
//            },
//            {
//            "l": "nist:1529345280:bd072993631f49cad555f14abe0763d0b4880dd71908d89b4d4d7be253c1e43b417c60bb4cb0bc4cf094f0f566c0ea3dd3aa622172ebd6e409341ff9ad6e639f"
//            },
//            {
//            "op": "sha-256"
//            },
//            {
//            "r": "8b2919ccd3a66db81d4eac01c09b79393397834446636849de2e5c9beffa741c"
//            },
//            {
//            "op": "sha-256"
//            },
//            {
//            "l": "0f139be12c981c646a837129de09f0e4e65c79dacbe19f652103c48e1ab9c096"
//            },
//            {
//            "op": "sha-256"
//            },
//            {
//            "r": "84b5f1bad349990a8e789be3cbb9a0691596400eb89bf32681f9044713b760b5"
//            },
//            {
//            "op": "sha-256"
//            },
//            {
//            "l": "1583785:1529345338:1:https://a.chainpoint.org:cal:1583785"
//            },
//            {
//            "r": "535f0aeaf90b27a8bb24b48c2f818fcf132baeb090db6208f823dce5b18edf8f"
//            },
//            {
//            "op": "sha-256"
//            },
//            {
//            "anchors": [
//            {
//            "type": "cal",
//            "anchor_id": "1583785",
//            "uris": [
//            "https://a.chainpoint.org/calendar/1583785/hash"
//            ]
//            }
//            ]
//            }
//            ]
//            }
//            ]
//        },
//        "anchors_complete": [
//        "cal"
//        ]
//    }
//]
