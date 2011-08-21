package ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 21/8/2011
	 */
	public class HealthBar extends FlxGroup
	{
		private var m_barBacking:FlxSprite;
		private var m_barChunks:FlxGroup;
		
		public function HealthBar() 
		{
			super();
			
			m_barBacking = new FlxSprite(8, FlxG.height -16);
			m_barBacking.makeGraphic(49, 8, 0xff400000);
			
			m_barChunks = new FlxGroup;
			for (var chunkLoop:int = 0; chunkLoop < 10; chunkLoop++)
			{
				var newChunk:FlxSprite = new FlxSprite(8 + chunkLoop * 5, FlxG.height -16);
				newChunk.makeGraphic(4, 8, 0xffff0000)
				m_barChunks.add(newChunk);
			}
			
			add(m_barBacking);
			add(m_barChunks);
		}
		
		public function updateHP(healthRemaining:Number):void
		{
			// health scale 0.0 - 1.0
			for (var stepLoop:int = 9; stepLoop >= 0; stepLoop--)
			{
				if (healthRemaining < stepLoop * 0.1 + 0.05)
				{
					var chunk:FlxSprite = m_barChunks.members[stepLoop];
					chunk.visible = false;
				}
				else
					break;
			}
		}
	}
}