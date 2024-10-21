//
//  URLRequestComponentsWrappable.swift
//  ulug_campus
//
//  Created by Александр Савченко on 19.08.2022.
//  Copyright © 2022 invertercant_dev. All rights reserved.
//

import Foundation



protocol URLRequestComponentsWrappable{
    func wrap(wrapee: URLRequestComponents) -> URLRequestComponents
}

extension Array where Element == URLRequestComponentsWrappable{
    
    func applyWraps(urlRequestComponents: URLRequestComponents) -> URLRequestComponents{
        return self.reduce(urlRequestComponents) { acc, element in
            return element.wrap(wrapee: acc)
        }
    }
    
}
