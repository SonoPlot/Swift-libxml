//
//  main.swift
//  XMLProfiler
//
//  Created by Janie Clayton-Hasz on 1/23/15.
//  Copyright (c) 2015 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

class ThrowAwayClassForParsing: NSObject, NSXMLParserDelegate {
    
    func parser(parser: NSXMLParser!,
        didStartElement elementName: String!,
        namespaceURI: String!, qualifiedName qName: String!,
        attributes attributeDict: [NSObject : AnyObject]!) {
            
    }
    
    func parser(parser: NSXMLParser!,
        didEndElement elementName: String!,
        namespaceURI: String!,
        qualifiedName qName: String!) {
            
    }
    
}

let myThrowawayDelegateClass = ThrowAwayClassForParsing()

func bundleResourceURL(resourceName:String) -> NSURL {
    let bundleURL = NSBundle.mainBundle().resourceURL
    return NSURL(string:resourceName, relativeToURL:bundleURL!)!
}

let largePatternFileString = "VeryLargeSpotGrid.pattern"

// Profiling Convenience function
func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    println("Time elapsed for \(title): \(timeElapsed) s")
}

// Need to load a file two different ways: NSFileHandler and NSData loadFromFile.
// Profile to find which is faster

func dataLoadFromFile() {
    // Is there more to this? I think I am missing something. -JKC
    let fileURL = bundleResourceURL(largePatternFileString)
    let patternData = NSData(contentsOfURL: fileURL)!
}

func dataLoadFromFileHandler() {
    
    // No, I am not doing any error handling and lots of this is really bad. -JKC
    // Is there more to this? I think I am missing something. -JKC
    let fileURL = bundleResourceURL(largePatternFileString)
    var myError: NSError? = nil
    let fileHandle = NSFileHandle(forReadingFromURL: fileURL, error: &myError)!
    let patternData = fileHandle.readDataToEndOfFile()
    println("dataLoadFromFileHandler pattern data length: \(patternData.length)")
    fileHandle.closeFile()
}


// Need to parse a file three different ways: Tree based and event based with either NSXMLParser or libxml2
// Profile to find which is faster

// Tree Based Parsing (NSXMLDocument)
func treeBasedParsingFromURL() {
    let fileURL = bundleResourceURL(largePatternFileString)

    var myError:NSError? = nil
    let xmlDocFromData = NSXMLDocument(contentsOfURL: fileURL, options: 0, error: &myError)!
    
    let rootElement = xmlDocFromData.rootElement()!
    let firstChild = rootElement.childAtIndex(0)!
}

func treeBasedParsingFromDataPersistedObject() {
    let fileURL = bundleResourceURL(largePatternFileString)
    let patternData = NSData(contentsOfURL: fileURL)!
    var myError:NSError? = nil
    let xmlDocFromData = NSXMLDocument(data: patternData, options: 0, error: &myError)
}


// Tree Based Parsing (libxml2)
func treeBasedParsingUsingLibxml() {
    let fileURL = bundleResourceURL(largePatternFileString)
    let document: xmlDocPtr = xmlParseFile(fileURL.fileSystemRepresentation)
    let nodePointer: xmlNodePtr = xmlDocGetRootElement(document)
    let nodeName = String.fromCString(UnsafePointer<CChar>(nodePointer.memory.name))
}


// Profile the times to parse
printTimeElapsedWhenRunningCode("Tree Based Parsing From URL") {
    treeBasedParsingFromURL()
}

printTimeElapsedWhenRunningCode("Tree Based Parsing From Data Persisted Object") {
    treeBasedParsingFromDataPersistedObject()
}

printTimeElapsedWhenRunningCode("Event Based Parsing Using NSXMLParser") {
    let patternURL = bundleResourceURL(largePatternFileString)
    let parser = NSXMLParser(contentsOfURL: patternURL)!

    parser.delegate = myThrowawayDelegateClass
    parser.parse()
}

printTimeElapsedWhenRunningCode("Tree Based Parsing Using libxml") {
    treeBasedParsingUsingLibxml()
}