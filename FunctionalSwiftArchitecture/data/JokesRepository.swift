//
//  JokesRepository.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

enum CachePolicy {
    case NetworkOnly
    case NetworkFirst
    case LocalOnly
    case LocalFirst
}

func getCategories<Context>(withPolicy policy: CachePolicy, andContextType: Context.Type) -> AsyncResult<Context, [Category]> where Context : JokeContext {
    switch policy {
    case .NetworkOnly:
        return getTransformedCategories(withContextType: andContextType)
    case .NetworkFirst:
        return getTransformedCategories(withContextType: andContextType) // TODO change to conditional call
    case .LocalOnly:
        return getTransformedCategories(withContextType: andContextType) // TODO change to local only cache call
    case .LocalFirst:
        return getTransformedCategories(withContextType: andContextType) // TODO change to conditional call
    }
}

func getRandomJoke<Context>(forCategoryName name: String, withPolicy policy: CachePolicy, andContextType: Context.Type) -> AsyncResult<Context, Joke> where Context : JokeContext{
    switch policy {
    case .NetworkOnly:
        return getTransformedRandomJoke(forCategoryName: name, withContextType: andContextType)
    case .NetworkFirst:
        return getTransformedRandomJoke(forCategoryName: name, withContextType: andContextType) // TODO change to conditional call
    case .LocalOnly:
        return getTransformedRandomJoke(forCategoryName: name, withContextType: andContextType) // TODO change to local only cache call
    case .LocalFirst:
        return getTransformedRandomJoke(forCategoryName: name, withContextType: andContextType) // TODO change to conditional call
    }
}

fileprivate func getTransformedCategories<Context>(withContextType: Context.Type) -> AsyncResult<Context, [Category]> where Context : JokeContext {
    return AsyncResult<Context, [Category]>.ask.flatMap { context in
        context.jokesDataSource.fetchAllJokeCategories().mapTT { categories in
            categories.map(mapToCategory)
        }
    }
}

fileprivate func getTransformedRandomJoke<Context>(forCategoryName categoryName: String, withContextType: Context.Type) -> AsyncResult<Context, Joke> where Context: JokeContext{
    return AsyncResult<Context, [Category]>.ask.flatMap { context in
        context.jokesDataSource.fetchRandomJoke(forCategoryName: categoryName).mapTT { jokeDto in
            mapToJoke(from: jokeDto)
        }
    }
}
