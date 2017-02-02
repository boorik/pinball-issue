package gameobj;

import Constants.TileType;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.system.FlxAssets;
import flixel.math.FlxPoint;
import nape.geom.Vec2;
using Lambda;

class CustomNapeTilemap extends FlxNapeTilemap
{
    public var spawnPoints(default, null) = new Array<FlxPoint>();
	public var leftFlippers(default, null) = new Array<FlxPoint>();
	public var rightFlippers(default, null) = new Array<FlxPoint>();
    public function new(tiles:String, graphics:FlxTilemapGraphicAsset, tileSize:Int)
    {
        super();
        loadMapFromCSV(tiles, graphics, tileSize, tileSize);
		
		
		for (leftFlipPoint in getTileCoords(TileType.LEFT_FLIPPER, false))
		{
			leftFlippers.push(leftFlipPoint);
			if (!setTile(Std.int(leftFlipPoint.x/16), Std.int(leftFlipPoint.y/16), 0))
			{
				trace("TILE WAS NOT UPDATED");
			}
		}
		
		for (rightFlipPoint in getTileCoords(TileType.RIGHT_FLIPPER, false))
		{
			rightFlippers.push(rightFlipPoint);
			setTile(Std.int(rightFlipPoint.x/16), Std.int(rightFlipPoint.y/16), 0);
		}
		
		
        setupTileIndices(TileType.BLOCK);

        var vertices = new Array<Vec2>();
        vertices.push(Vec2.get(16, 0));
        vertices.push(Vec2.get(16, 16));
        vertices.push(Vec2.get(0, 16));
        placeCustomPolygon(TileType.SLOPE_SE, vertices);
        vertices[0] = Vec2.get(0, 0);
        placeCustomPolygon(TileType.SLOPE_SW, vertices);
        vertices[1] = Vec2.get(16, 0);
        placeCustomPolygon(TileType.SLOPE_NW, vertices);
        vertices[2] = Vec2.get(16, 16);
        placeCustomPolygon(TileType.SLOPE_NE, vertices);
        
        for (ty in 0...heightInTiles)
        {
            var prevOneWay = false;
            var length:Int = 0;
            var startX:Int = 0;
            var startY:Int = 0;

            for (tx in 0...widthInTiles)
            {
                if (TileType.ONE_WAY.has(getTileByIndex(ty * widthInTiles + tx)))
                {
                    if (!prevOneWay)
                    {
                        prevOneWay = true;
                        length = 0;
                        startX = tx;
                        startY = ty;
                    }
                    length++;
                }
            }

        }

        //for (point in getTileCoords(TileType.SPAWN, false))
        //{
            //point.x += _scaledTileHeight * 0.5; 
			//
            //spawnPoints.push(point);
        //}
    }
}