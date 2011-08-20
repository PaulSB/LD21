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
		private const ROOM_DRAW_X:int = FlxG.width / 2 - 9;
		private const ROOM_DRAW_Y:int = 12;
		
		public function Level() 
		{
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
					
					x += tile.width / 2;
					y += tile.height / 2;
				}
				
				x = ROOM_DRAW_X - j * tile.width / 2;
				y = ROOM_DRAW_Y + j * tile.height / 2;
			}
		}
	}
}