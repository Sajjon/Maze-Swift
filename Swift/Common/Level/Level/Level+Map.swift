//
//  Level+Map.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-25.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import Foundation

// MARK: Map
public extension GenericLevel {
    
    struct Map<MapTile>:
        Equatable,
        Collection
        where
        MapTile: Equatable
    {
        
        /// Size of level in abstract length units, this abstract measurement is meant to be screen/resolution agnostic.
        public let size: AbstractSize
        public let tilesByRowAndColumn: [[MapTile]]
        
        public init(
            tilesByRowAndColumn: [[MapTile]]
        ) throws {
            guard let firstRow = tilesByRowAndColumn.first else {
                throw Error.cannotBeEmpty
            }
            
            for (rowIndex, row) in tilesByRowAndColumn.dropFirst().enumerated() {
                if row.count != firstRow.count {
                    throw Error.allRowsMustHaveSameLengthAsFirstRow(
                        lengthOfFirstRow: firstRow.count,
                        butRowAtIndex: rowIndex,
                        hasLength: row.count
                    )
                }
            }
            let width = firstRow.count
            let height = tilesByRowAndColumn.count
            self.size = try AbstractSize(
                width: width,
                height: height
            )
            self.tilesByRowAndColumn = tilesByRowAndColumn
        }
    
    }
}

public extension GenericLevel.Map {
    var width: AbstractLengthUnit { size.width }
    var height: AbstractLengthUnit { size.height }
    
    var cgWidth: CGFloat { CGFloat(width.value) }
    var cgHeight: CGFloat { CGFloat(height.value) }
}

// MARK: Error
public extension GenericLevel.Map {
    enum Error: Swift.Error {
        case cannotBeEmpty
        case allRowsMustHaveSameLengthAsFirstRow(
            lengthOfFirstRow: Int,
            butRowAtIndex: Int,
            hasLength: Int
        )
    }
}

public struct TileAt<Tile, Position>: Equatable
where
    Tile: Equatable,
    Position: Equatable
{
    public let tile: Tile
    public let position: Position
}


// MARK: Collection
public extension GenericLevel.Map {
    typealias MapTileAt = TileAt<MapTile, GridPosition>
    typealias Element = MapTileAt
    typealias Index = GridPosition
    
    /// This is the global position in the grid, i.e. rowWidth*x + y
    typealias TileIndex = Int
    
    var startIndex: GridPosition {
        .zero
    }
    
    var endIndex: GridPosition {
        GridPosition(x: width.value-1, y: height.value-1)
    }
    
    subscript(row: Int, column: Int) -> Element {
        get {
            guard row < height.value else {
                fatalError("Out of bounds, row")
            }
            guard column < width.value else {
                fatalError("Out of bounds, column")
            }
            
            return MapTileAt(
                tile: tilesByRowAndColumn[row][column],
                position: .init(x: column, y: row)
            )
        }
    }

    
    subscript(tileIndex: TileIndex) -> Element {
        get {
            return self[toGridPositionFrom(tileIndex: tileIndex)]
        }
    }

    subscript(gridPosition: GridPosition) -> Element {
        self[Int(gridPosition.y), Int(gridPosition.x)]
    }
    
    func index(after index: Index) -> Index {
        let after: Index
        if index.x < (width.value - 1) {
            after = Index(x: index.x + 1, y: index.y)
        } else {
            after = Index(x: 0, y: index.y + 1)
        }
    
        return after
    }
}

// MARK: Internal
internal extension GenericLevel.Map {
    
    var rowWidth: TileIndex { .init(width.value) }
    var colummnHeight: TileIndex { .init(height.value) }
    
    func toGridPositionFrom(tileIndex: TileIndex) -> GridPosition {
        let columnIndex = tileIndex % rowWidth
        let (rowIndex, isOverflowing) = (tileIndex - columnIndex).remainderReportingOverflow(dividingBy: rowWidth)
        assert(!isOverflowing, "division should result in non floating number")
        return GridPosition(x: columnIndex, y: rowIndex)
    }
    
    func toTileIndexFrom(gridPosition: GridPosition) -> TileIndex {
        let tileIndex = rowWidth * TileIndex(gridPosition.y) + TileIndex(gridPosition.x)
        return tileIndex
    }
}
