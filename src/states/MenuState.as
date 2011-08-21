package states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class MenuState extends FlxState
	{
		private static var m_escapesThisSession:int = -1;
		
		override public function create():void 
		{
			super.create();
			
			// Title text
			var tTxt:FlxText;
			tTxt = new FlxText(0, FlxG.height / 2 -12, FlxG.width, "ESCAPE");
			tTxt.setFormat(null, 16, 0xffffffff, "center");
			this.add(tTxt);
			
			// Instruction text
			tTxt = new FlxText(0, FlxG.height -12, FlxG.width, "Press ESCAPE to BEGIN");
			tTxt.setFormat(null, 8, 0xffffffb0, "center");
			this.add(tTxt);
			
			// Stat text
			m_escapesThisSession++;
			if (m_escapesThisSession > 0)
			{
				if (m_escapesThisSession == 1)
					tTxt = new FlxText(0, 0, FlxG.width, m_escapesThisSession + " \"escape\" this session");
				else
					tTxt = new FlxText(0, 0, FlxG.width, m_escapesThisSession + " \"escapes\" this session");
				tTxt.setFormat(null, 8, 0xffff8080, "center");
				this.add(tTxt);
			}
		}
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				FlxG.fade(0xff000000, 0.5, onFade);
			}
			super.update();
		}
		
		private function onFade():void
		{
			FlxG.switchState( new PlayState() );
		}
	}
}