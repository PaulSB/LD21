package states 
{
	import game.Enemy;
	import game.Player;
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
		private var m_player:Player;
		private var m_enemy:Enemy;	// Test enemy
		
		public static var s_layerBackground:FlxGroup;
		public static var s_layerInScene:FlxGroup;
		
		public function PlayState() 
		{
			m_levelManager = new LevelManager;
			m_currentLevel = m_levelManager.getCurrentRoom();
			
			m_player = new Player(Level.ROOM_DRAW_X + 3, Level.ROOM_DRAW_Y + m_currentLevel.m_tileHeight / 2);
			
			m_enemy = new Enemy(80, 80);	// Test enemy
			
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_currentLevel);
			
			s_layerInScene = new FlxGroup;
			s_layerInScene.add(m_player);
			s_layerInScene.add(m_enemy);
			
			add(s_layerBackground);
			add(s_layerInScene);
		}
		
		override public function update():void 
		{
			s_layerInScene.sort("y", ASCENDING);
			
			super.update();
		}
	}
}