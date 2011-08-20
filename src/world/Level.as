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
	}
}