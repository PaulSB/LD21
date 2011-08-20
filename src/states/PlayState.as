package states 
{
	import game.Enemy;
	import game.Player;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	//import org.flixel.FlxU;
	import world.Level;
	import world.LevelManager;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class PlayState extends FlxState
	{	
		private var m_levelManager:LevelManager;
		static public var m_currentLevel:Level;	// Current room reference
		
		private var m_player:Player;
		private var m_enemies:FlxGroup;	// Test enemy
		
		public static var s_layerBackground:FlxGroup;
		public static var s_layerInScene:FlxGroup;
		
		public function PlayState() 
		{
			m_levelManager = new LevelManager;
			m_currentLevel = m_levelManager.getCurrentRoom();
			
			m_player = new Player(Level.ROOM_DRAW_X + 3, Level.ROOM_DRAW_Y + m_currentLevel.m_tileHeight / 2);
			
			m_enemies = new FlxGroup;
			m_enemies.add(new Enemy(80, 60));	// Test enemy
			m_enemies.add(new Enemy(120, 40));	// Test enemy
			
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_currentLevel);
			
			s_layerInScene = new FlxGroup;
			s_layerInScene.add(m_player);
			for each (var enemy:Enemy in m_enemies.members)
			{
				s_layerInScene.add(enemy);
			}
			
			add(s_layerBackground);
			add(s_layerInScene);
		}
		
		override public function update():void 
		{
			// Player-enemy collisions
			if (FlxG.collide(m_enemies, m_player))
			{
				var maxX:Number = m_currentLevel.getMaxXForY(m_player.getCentreStandingPos().y);
				var maxY:Number = m_currentLevel.getMaxYForX(m_player.getCentreStandingPos().x);
				
				var displacement:int = 0;
				if (m_player.justTouched(FlxObject.LEFT))
				{
					while ((m_player.x < maxX && m_player.x > -maxX) && (displacement < 4))
					{
						m_player.x++;
						displacement++;
					}
				}
				if (m_player.justTouched(FlxObject.RIGHT))
				{
					while ((m_player.x < maxX && m_player.x > -maxX) && (displacement < 4))
					{
						m_player.x--;
						displacement++;
					}
				}
				if (m_player.justTouched(FlxObject.UP))
				{
					while ((m_player.y < maxY && m_player.y > -maxY) && (displacement < 4))
					{
						m_player.y++;
						displacement++;
					}
				}
				if (m_player.justTouched(FlxObject.DOWN))
				{
					while ((m_player.y < maxY && m_player.y > -maxY) && (displacement < 4))
					{
						m_player.y--;
						displacement++;
					}
				}
					
				m_player.hurt(0.1);
			}
			
			// Enemy-enemy collisions
			FlxG.collide(m_enemies, m_enemies);
			
			// Enemy targetting
			for each (var enemy:Enemy in m_enemies.members)
			{
				enemy.setTargetPos(m_player.getCentreStandingPos().x, m_player.getCentreStandingPos().y);
			}
			
			s_layerInScene.sort("y", ASCENDING);
			
			super.update();
		}
	}
}