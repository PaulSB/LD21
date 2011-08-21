package states 
{
	import game.Enemy;
	import game.Player;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
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
		
		private var m_instructionText:FlxText;
		private var m_instructionTarget:FlxSprite = null;
		
		public static var s_layerBackground:FlxGroup;
		public static var s_layerInScene:FlxGroup;
		public static var s_layerForeground:FlxGroup;
		public static var s_layerOSD:FlxGroup;
		
		public function PlayState() 
		{
			m_levelManager = new LevelManager;
			m_currentLevel = m_levelManager.getCurrentRoom();
			
			m_player = new Player(Level.ROOM_DRAW_X + 3, Level.ROOM_DRAW_Y + m_currentLevel.m_tileHeight / 2);
			
			m_enemies = new FlxGroup;
			m_enemies.add(new Enemy(80, 60));	// Test enemy
			m_enemies.add(new Enemy(120, 40));	// Test enemy
			
			m_instructionText = new FlxText(0, 0, FlxG.width);
			m_instructionText.setFormat(null, 8, 0xffffff, "center");
			m_instructionText.visible = false;
			
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_currentLevel.m_floor);
			
			s_layerInScene = new FlxGroup;
			s_layerInScene.add(m_player);
			for each (var enemy:Enemy in m_enemies.members)
			{
				s_layerInScene.add(enemy);
			}
			
			s_layerForeground = new FlxGroup;
			
			if (m_currentLevel.m_door_NE)
				s_layerBackground.add(m_currentLevel.m_door_NE);
			if (m_currentLevel.m_door_SE)
				s_layerForeground.add(m_currentLevel.m_door_SE);
			if (m_currentLevel.m_door_SW)
				s_layerForeground.add(m_currentLevel.m_door_SW);
			if (m_currentLevel.m_door_NW)
				s_layerBackground.add(m_currentLevel.m_door_NW);
				
			s_layerOSD = new FlxGroup;
			s_layerOSD.add(m_instructionText);
			
			add(s_layerBackground);
			add(s_layerInScene);
			add(s_layerForeground);
			add(s_layerOSD);
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
					
				m_player.hurt(0.0);// (0.1);	// TEMP invincible for testing
			}
			
			// Enemy-enemy collisions
			FlxG.collide(m_enemies, m_enemies);
			
			// Enemy targetting
			for each (var enemy:Enemy in m_enemies.members)
			{
				enemy.setTargetPos(m_player.getCentreStandingPos().x, m_player.getCentreStandingPos().y);
			}
			
			// Item instructions
			if (m_currentLevel.m_door_NE && m_currentLevel.m_neighbour_NE && FlxG.overlap(m_player, m_currentLevel.m_door_NE))
			{
				m_instructionText.text = "Press SPACE to use DOOR";
				m_instructionText.visible = true;
				m_instructionTarget = m_currentLevel.m_door_NE;
			}
			else if (m_currentLevel.m_door_SE && m_currentLevel.m_neighbour_SE && FlxG.overlap(m_player, m_currentLevel.m_door_SE))
			{
				m_instructionText.text = "Press SPACE to use DOOR";
				m_instructionText.visible = true;
				m_instructionTarget = m_currentLevel.m_door_SE;
			}
			else if (m_currentLevel.m_door_SW && m_currentLevel.m_neighbour_SW && FlxG.overlap(m_player, m_currentLevel.m_door_SW))
			{
				m_instructionText.text = "Press SPACE to use DOOR";
				m_instructionText.visible = true;
				m_instructionTarget = m_currentLevel.m_door_SW;
			}
			else if (m_currentLevel.m_door_NW && m_currentLevel.m_neighbour_NW && FlxG.overlap(m_player, m_currentLevel.m_door_NW))
			{
				m_instructionText.text = "Press SPACE to use DOOR";
				m_instructionText.visible = true;
				m_instructionTarget = m_currentLevel.m_door_NW;
			}
			else
			{
				m_instructionText.visible = false;
				m_instructionTarget = null;
			}
			
			// Item actions
			if (m_instructionText.visible)
			{
				if (FlxG.keys.justPressed("SPACE"))
				{
					var nextRoom:Level = null;
					if (m_instructionTarget == m_currentLevel.m_door_NE)
					{
						nextRoom = m_currentLevel.m_neighbour_NE;
						m_player.x = Level.ROOM_DRAW_X - 2.0 * m_currentLevel.m_tileWidth;
						m_player.y = Level.ROOM_DRAW_Y + 6.0 * m_currentLevel.m_tileHeight;
					}
					else if (m_instructionTarget == m_currentLevel.m_door_SE)
					{
						nextRoom = m_currentLevel.m_neighbour_SE;
						m_player.x = Level.ROOM_DRAW_X - 2.0 * m_currentLevel.m_tileWidth;
						m_player.y = Level.ROOM_DRAW_Y + 3.0 * m_currentLevel.m_tileHeight;
					}
					else if (m_instructionTarget == m_currentLevel.m_door_SW)
					{
						nextRoom = m_currentLevel.m_neighbour_SW;
						m_player.x = Level.ROOM_DRAW_X + 2.0 * m_currentLevel.m_tileWidth;
						m_player.y = Level.ROOM_DRAW_Y + 3.0 * m_currentLevel.m_tileHeight;
					}
					else if (m_instructionTarget == m_currentLevel.m_door_NW)
					{
						nextRoom = m_currentLevel.m_neighbour_NW;
						m_player.x = Level.ROOM_DRAW_X + 2.0 * m_currentLevel.m_tileWidth;
						m_player.y = Level.ROOM_DRAW_Y + 6.0 * m_currentLevel.m_tileHeight;
					}
					
					if (nextRoom)
					{
						// Room transition
						s_layerBackground.replace(m_currentLevel.m_floor, nextRoom.m_floor);
						if (m_currentLevel.m_door_NE)
							s_layerBackground.remove(m_currentLevel.m_door_NE, true);
						if (m_currentLevel.m_door_SE)
							s_layerForeground.remove(m_currentLevel.m_door_SE, true);
						if (m_currentLevel.m_door_SW)
							s_layerForeground.remove(m_currentLevel.m_door_SW, true);
						if (m_currentLevel.m_door_NW)
							s_layerBackground.remove(m_currentLevel.m_door_NW, true);
						
						m_levelManager.changeCurrentRoom(nextRoom.m_roomIndex);	
						m_currentLevel = m_levelManager.getCurrentRoom();
						
						if (m_currentLevel.m_door_NE)
							s_layerBackground.add(m_currentLevel.m_door_NE);
						if (m_currentLevel.m_door_SE)
							s_layerForeground.add(m_currentLevel.m_door_SE);
						if (m_currentLevel.m_door_SW)
							s_layerForeground.add(m_currentLevel.m_door_SW);
						if (m_currentLevel.m_door_NW)
							s_layerBackground.add(m_currentLevel.m_door_NW);
							
						// Populate
						for each (var oldEnemy:Enemy in m_enemies.members)
						{
							s_layerInScene.remove(oldEnemy, true);
						}
						
						m_enemies = new FlxGroup;
						m_enemies.add(new Enemy(80, 60));	// Test enemy
						m_enemies.add(new Enemy(120, 40));	// Test enemy
						m_enemies.add(new Enemy(60, 80));	// Test enemy

						for each (var newEnemy:Enemy in m_enemies.members)
						{
							s_layerInScene.add(newEnemy);
						}
					}
				}
			}
			
			s_layerInScene.sort("y", ASCENDING);
			
			super.update();
		}
	}
}