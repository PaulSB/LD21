package game 
{
	import org.flixel.FlxSprite;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 21/8/2011
	 */
	public class Loot extends FlxSprite
	{
		[Embed(source = '../../data/textures/loot.png')] private var imgLoot:Class;
		
		public function Loot(xLeft:Number, yBottom:Number, colour:uint = 0xffffffff) 
		{
			super(xLeft, yBottom);
			
			loadGraphic(imgLoot);
			y -= height;
			
			// Adjust collision rect:
			offset.y = (height - width);
			height -= offset.y;
			y += offset.y;
			
			color = colour;
			alpha = 0.75;
		}
	}
}