package world 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	//import org.flixel.FlxU;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class Level extends FlxGroup
	{
		[Embed(source = '../../data/textures/tile_floor.png')] private var imgTileFloor:Class;
		
		private const ROOM_TILE_SIZE:int = 9;
		static public const ROOM_DRAW_X:int = FlxG.width / 2 - 9;
		static public const ROOM_DRAW_Y:int = 12;
		
		public var m_tileWidth:int = 0;
		public var m_tileHeight:int = 0;
		
		public function Level() 
		{
			super();
			
			// Create level
			var r:Number = (Math.random() * 255.0);
			var g:Number = (Math.random() * 255.0);
			var b:Number = (Math.random() * 255.0);
			var roomColour:uint = 0xff000000 + (r << 16) + (g << 8) + b;
			
			var x:int = ROOM_DRAW_X, y:int = ROOM_DRAW_Y;
			for (var j:int = 0; j <= ROOM_TILE_SIZE; ++j)
			{
				for (var i:int = 0; i < ROOM_TILE_SIZE; ++i)
				{
					var tile:FlxSprite = new FlxSprite(x,y);
					tile.loadGraphic(imgTileFloor);
					tile.color = roomColour;
					add(tile);
					
					m_tileWidth = tile.width;
					m_tileHeight = tile.height;
					x += m_tileWidth / 2;
					y += m_tileHeight / 2;
				}
				
				x = ROOM_DRAW_X - j * tile.width / 2;
				y = ROOM_DRAW_Y + j * tile.height / 2;
			}
		}
		
		public function IsInLevelBounds(xPos:Number, yPos:Number):Boolean
		{
			var roomWidth:Number = m_tileWidth * ROOM_TILE_SIZE;
			var roomHeight:Number = m_tileHeight * ROOM_TILE_SIZE;
			var roomCentreX:Number = ROOM_DRAW_X + (m_tileWidth / 2.0);
			var roomCentreY:Number = ROOM_DRAW_Y + (roomHeight);
			
			var maxXforY:Number;
			var offsetY:Number;
			if (yPos < roomCentreY)
			{
				offsetY = roomCentreY - yPos;
			}
			else
			{
				offsetY = yPos - roomCentreY;
			}
			maxXforY = (offsetY / (roomHeight)) * (roomWidth);
			
			var maxYforX:Number;
			var offsetX:Number;
			if (xPos < roomCentreX)
			{
				offsetX = roomCentreX - xPos;
			}
			else
			{
				offsetX = xPos - roomCentreX;
			}
			maxYforX = (1 - offsetX / (roomWidth)) * (roomHeight);
			
			// Result
			if ((xPos - 4 <= roomCentreX - maxXforY) || (xPos + 4 >= roomCentreX + maxXforY))
			{
				return false;
			}
			else if ((yPos - 4 <= roomCentreY - maxYforX) || (yPos + 4 >= roomCentreY + maxYforX))
			{
				return false;
			}
			
			return true;
		}
	}
}