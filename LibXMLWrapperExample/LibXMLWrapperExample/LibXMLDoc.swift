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


class LibXMLDoc {
    
    let document: xmlDocPtr
    private weak var internalRootNode: LibXMLNode?
    
    init(xmlURL: NSURL) {
        document = xmlParseFile(xmlURL.fileSystemRepresentation)
    }
    
    deinit {
        xmlFreeDoc(document)
    }
    
    var rootNode:LibXMLNode? {
        if let previousRootNode = internalRootNode {
            return previousRootNode
        } else {
            let myRootNode = xmlDocGetRootElement(document)
            if myRootNode != nil {
                let computedRootNode = LibXMLNode(xmlNode: myRootNode, xmlDocument: self)
                internalRootNode = computedRootNode
                return computedRootNode
            } else {
                return nil
            }
        }
    }
    
}

func bundleResourceURL(resourceName:String) -> NSURL {
    let bundleURL = NSBundle.mainBundle().resourceURL
    return NSURL(string:resourceName, relativeToURL:bundleURL!)!
}