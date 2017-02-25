//
//  StorageManager.swift
//  LevelDesigner
//
//  Created by limte on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import Foundation

class StorageManager {
    private var levels: [Level] = []
    private let PATH_LEVEL_NAME = "level-object"
    
    init() {
        levels = loadLevelObject()
    }
    
    private func getLevelObjectPath() -> String? {
        let fileManger = FileManager.default
        guard let url = fileManger.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(PATH_LEVEL_NAME).path
    }
    
    private func getLevelContentsPath(_ levelName: String) -> String? {
        let fileManger = FileManager.default
        guard let url = fileManger.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(levelName).path
    }

    public func doesLevelExist(level: Level) -> Bool {
        return levels.contains(level)
    }
    
    // save without overwrite the level
    public func saveLevelStars(level: Level) -> Bool {
        /*
         guard levelName != "" else {
         return false
         }
         */

        guard let levelObjectPath = getLevelObjectPath() else {
            return false
        }
        
        if !levels.contains(level) {
            levels.append(level)
        } else {
            if let index = levels.index(of: level) {
                levels[index].setStars(level.getStars())
            }
        }
        
        NSKeyedArchiver.archiveRootObject(levels, toFile: levelObjectPath)
        return true
    }
    
    // save level with given levelName, overwrite the content if same levelName exists
    public func save(level: Level, bubbles: [[GridBubble]]) -> Bool {
        /*
        guard levelName != "" else {
            return false
        }
        */
        
        guard let levelObjectPath = getLevelObjectPath() else {
            return false
        }
        
        guard let levelContentsPath = getLevelContentsPath(level.levelName) else {
            return false
        }
        
        if levels.contains(level) {
            if let index = levels.index(of: level) {
                levels[index] = level
            }
        } else {
            levels.append(level)
        }
        
        NSKeyedArchiver.archiveRootObject(levels, toFile: levelObjectPath)
        NSKeyedArchiver.archiveRootObject(bubbles, toFile: levelContentsPath)
        return true
    }
    
    private func loadLevelObject() -> [Level] {
        guard let levelObjectPath = getLevelObjectPath() else {
            return []
        }
        
        guard let levels = NSKeyedUnarchiver.unarchiveObject(withFile: levelObjectPath) as? [Level] else {
            return []
        }
        
        return levels
    }
    
    public func loadLevel(levelName: String) -> [[GridBubble]]? {
        guard let levelContentsPath = getLevelContentsPath(levelName) else {
            return nil
        }
        
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: levelContentsPath) as? [[GridBubble]] else {
            return nil
        }
        return data
    }
    
    public func getLevelNames() -> [String] {
        var levelNames = [String]()
        for level in levels {
            levelNames.append(level.levelName)
        }
        return levelNames
    }
    
    public func getLevels() -> [Level] {
        return levels
    }
}


