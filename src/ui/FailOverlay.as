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
		private const TOTAL_WIDTH:int = 120;
		private const TOTAL_HEIGHT:int = 80;
		
		private var m_statsText1:FlxText;
		private var m_statsText2:FlxText;
		
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
			
			m_statsText1 = new FlxText(xLeft, yTop + TOTAL_HEIGHT * 0.6, TOTAL_WIDTH, "You visited 00 rooms");
			m_statsText1.setFormat(null, 8, 0xffffff, "center");
			m_statsText2 = new FlxText(xLeft, yTop + TOTAL_HEIGHT * 0.8, TOTAL_WIDTH, "in 00 mins 00 seconds");
			m_statsText2.setFormat(null, 8, 0xffffff, "center");
			add(m_statsText1);
			add(m_statsText2);
		}
		
		public function setStats(time:Number, roomCount:int):void
		{
			var minutes:int = time / 60;
			var seconds:int = time % 60;
			if (minutes > 0)
			{
				m_statsText1.text = "You visited " + roomCount + " rooms";
				m_statsText2.text = "in " + minutes + " mins " + seconds + " seconds";
			}
			else
			{
				m_statsText1.text = "You visited " + roomCount + " rooms";
				m_statsText2.text = "in " + seconds + " seconds";
			}
		}
	}
}