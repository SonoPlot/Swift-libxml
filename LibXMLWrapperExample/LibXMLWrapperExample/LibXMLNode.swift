//    Copyright (c) <2015>, <Red Queen Coder, LLC>
//    All rights reserved.
//
//    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//    1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//    2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
//    GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation

class LibXMLNode {
    
    private let xmlNode: xmlNodePtr
    let xmlDocument: LibXMLDoc
    
    init(xmlNode: xmlNodePtr, xmlDocument: LibXMLDoc) {
        self.xmlNode = xmlNode
        self.xmlDocument = xmlDocument
    }
    
    deinit {
        // maybe deallocate the xmlNode
    }
    
    lazy var nodeName: String = {
        return String.fromCString(UnsafePointer<CChar>(self.xmlNode.memory.name))!
    }()
    
    lazy var nodeChildren: [LibXMLNode] = {
        
        // This is going to be an array of XML_ELEMENT_NODE
        var array = [LibXMLNode]()
        
        let currentNode = self.xmlNode.memory.children
        
        
        
        for var currentNodePtr = currentNode; currentNodePtr != nil; currentNodePtr = currentNodePtr.memory.next {
            let childNode = LibXMLNode(xmlNode: currentNodePtr, xmlDocument: self.xmlDocument)
            
            // xmlNodeIsText() returns a status of 1 if the node is a text node and 0 if it is not.
            // We want to append the child node only if we know it isn't a text node. -JKC
            if xmlNodeIsText(currentNodePtr) == 0 {
                array.append(childNode)
            }
        }
        
        return array
    }()
    
    lazy var nodeValue: String? = {
        let textValue = xmlNodeListGetString(self.xmlDocument.document, self.xmlNode.memory.children, 1)
        if (textValue != nil) {
            let nodeString = String.fromCString(UnsafePointer<CChar>(textValue))!
            free(textValue)
            return nodeString
        } else {
            return nil
        }
    }()
    
}

func outputXMLTree(nodeParameter:LibXMLNode, indentLevel:Int = 0) -> (){
    
    let nodes = nodeParameter.nodeChildren

    var tabs:String = ""
    for currentTab in (0..<indentLevel) {
        tabs = tabs + "\t"
    }
    
    // For all the switch statements that take node count or node name, also pass in the node value.
    // Do not use if-let. Use wild card or check for .Some to make sure the value exists before force unwrapping it. -JKC
    for node in nodes {
        switch (node.nodeChildren.count, node.nodeValue) {
        case (0, .Some):
            let value:NSString = node.nodeValue!
            println("\(tabs) \(node.nodeName): \(value)")
            break
        case (0, .None):
            println("\(tabs) \(node.nodeName)")
                break
        default:
            println("\(tabs) \(node.nodeName)")
            outputXMLTree(node, indentLevel: indentLevel+1)
            break
        }
    }
    
   
}