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
        
        private let _hasNodeAt: (MapTileAt) -> Bool
        
        public init(
            tilesByRowAndColumn: [[MapTile]],
            hasNodeAt: @escaping (MapTileAt) -> Bool
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
            
            self.size = try AbstractSize(width: firstRow.count, height: tilesByRowAndColumn.count)
            self.tilesByRowAndColumn = tilesByRowAndColumn
            self._hasNodeAt = hasNodeAt
        }
    
    }
}

public extension GenericLevel.Map {
    var width: AbstractLengthUnit { size.width }
    var height: AbstractLengthUnit { size.height }
    
    var cgWidth: CGFloat { CGFloat(width.value) }
    var cgHeight: CGFloat { CGFloat(height.value) }
    
    func shouldGraphCreateNode(at gridPosition: GridPosition) -> Bool {
        _hasNodeAt(self[gridPosition])
    }
    
    func shouldGraphCreateNode(for mapTileAt: MapTileAt) -> Bool {
          _hasNodeAt(mapTileAt)
      }
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

// MARK: Equatable
public extension GenericLevel.Map {
    static func  == (lhs: Self, rhs: Self) -> Bool {
        lhs.tilesByRowAndColumn == rhs.tilesByRowAndColumn
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
    
    var startIndex: Index {
        .zero
    }
    
    var endIndex: Index {
        Index(x: width.value, y: height.value)
    }
    
    subscript(row: Int, column: Int) -> Element {
        get {
            guard row < rowWidth else {
                fatalError("Out of bounds, row")
            }
            guard column < colummnHeight else {
                fatalError("Out of bounds, column")
            }
            
            return MapTileAt(
                tile: tilesByRowAndColumn[row][column],
                position: .init(x: row, y: column)
            )
        }
    }

    
    subscript(tileIndex: TileIndex) -> Element {
        get {
            return self[toGridPositionFrom(tileIndex: tileIndex)]
        }
    }
 
    
    subscript(gridPosition: GridPosition) -> Element {
        self[Int(gridPosition.x), Int(gridPosition.y)]
    }
    
    func index(after index: Index) -> Index {
        if index.x < (rowWidth - 1) {
            return Index(x: index.x + 1, y: index.y)
        } else {
            return Index(x: 0, y: index.y + 1)
        }
    }
}

// MARK: Private
private extension GenericLevel.Map {
    
    var rowWidth: TileIndex { .init(width.value) }
    var colummnHeight: TileIndex { .init(height.value) }
    
    private func toGridPositionFrom(tileIndex: TileIndex) -> GridPosition {
        let (rowIndex, _) = tileIndex.remainderReportingOverflow(dividingBy: rowWidth)
        let columnIndex = tileIndex % rowWidth
        return GridPosition(x: rowIndex, y: columnIndex)
    }
    
    private func toTileIndexFrom(gridPosition: GridPosition) -> TileIndex {
        let tileIndex = rowWidth * TileIndex(gridPosition.x) + TileIndex(gridPosition.y)
        return tileIndex
    }
}
