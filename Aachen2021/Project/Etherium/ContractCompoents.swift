import Foundation


enum ContractMethods:  String {

    case writeContract       = "saveContractParticipants"
    case readSenderName      = "getSenderName"
    case readReceiverName    = "getReceiverName"
    case readObserverName    = "getObserverNames"
    case readDate            = "getDate"
    case readTransactionHash = "getHashedData"
}

let contractAddress = "0xD407b64b7d61CCC458A88d0DD817cE1B6be341EB"

let contractABI =
    """
[
    {
        "inputs": [],
        "name": "getDate",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getHashedData",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getObserverNames",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getReceiverName",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getSenderName",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "SenderName",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "ReceiverName",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "ObserverNames",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "transactionDate",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "hashedData",
                "type": "string"
            }
        ],
        "name": "saveContractParticipants",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]
"""
