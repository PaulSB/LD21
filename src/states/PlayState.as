package states 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	import world.Level;
	import world.LevelManager;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class PlayState extends FlxState
	{	
		private var m_levelManager:LevelManager;
		private var m_currentLevel:Level;	// Current room reference
		
		public static var s_layerBackground:FlxGroup;
		
		public function PlayState() 
		{
			m_levelManager = new LevelManager;
			m_currentLevel = m_levelManager.getCurrentRoom();
			
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_currentLevel);
			
			add(s_layerBackground);
		}
	}
}