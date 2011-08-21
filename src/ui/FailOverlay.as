package ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 21/8/2011
	 */
	public class FailOverlay extends FlxGroup
	{
		private const TOTAL_WIDTH:int = 100;
		private const TOTAL_HEIGHT:int = 80;
		
		public function FailOverlay() 
		{
			var xLeft:int = (FlxG.width - TOTAL_WIDTH) / 2;
			var yTop:int = 20;
			
			var backing:FlxSprite = new FlxSprite(xLeft, yTop);
			backing.makeGraphic(TOTAL_WIDTH, TOTAL_HEIGHT, 0x80400000);
			add(backing);
			
			var deadText:FlxText = new FlxText(xLeft, yTop, TOTAL_WIDTH, "You have PERISHED");
			deadText.setFormat(null, 16, 0xffffff, "center", 0x400000);
			add(deadText);
		}
	}
}