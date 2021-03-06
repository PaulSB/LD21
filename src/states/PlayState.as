package states 
{
	import game.Enemy;
	import game.Loot;
	import game.Player;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import ui.FailOverlay;
	import ui.HealthBar;
	import ui.WinOverlay;
	import world.Background;
	import world.Level;
	import world.LevelManager;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class PlayState extends FlxState
	{	
		[Embed(source = '../../data/sound/door.mp3')] private var sndDoor:Class;
		[Embed(source = '../../data/sound/pickup.mp3')] private var sndPickUp:Class;
		[Embed(source = '../../data/sound/drop.mp3')] private var sndDrop:Class;
		[Embed(source = '../../data/sound/hurt1.mp3')] private var sndHurt1:Class;
		[Embed(source = '../../data/sound/hurt2.mp3')] private var sndHurt2:Class;
		[Embed(source = '../../data/sound/music.mp3')] private var sndMusic:Class;
		
		private var m_levelManager:LevelManager;
		static public var m_currentLevel:Level;	// Current room reference
		
		private var m_player:Player;
		private var m_enemies:FlxGroup;	// Test enemy
		private var m_backgroundGFX:Background;
		
		private var m_instructionText:FlxText;
		private var m_instructionTarget:FlxSprite = null;
		private var m_healthBar:HealthBar;
		private var m_failOverlay:FailOverlay;
		private var m_winOverlay:WinOverlay;
		private var m_muteText:FlxText;
		
		public static var s_layerBackground:FlxGroup;
		public static var s_layerInScene:FlxGroup;
		public static var s_layerForeground:FlxGroup;
		public static var s_layerOSD:FlxGroup;
		
		// A couple of stats to track
		private var m_roomsTraversed:Array;
		private var m_gameTime:Number;
		
		// Sound
		private var m_sfxDoor:FlxSound;
		private var m_sfxPickUp:FlxSound;
		private var m_sfxDrop:FlxSound;
		private var m_sfxHurt1:FlxSound;
		private var m_sfxHurt2:FlxSound;
		//private var m_music:FlxSound;
		
		private static var s_myMute:Boolean = false;	// <- FlxG.mute giving me problems...
		
		override public function create():void 
		{
			super.create();
			
			m_backgroundGFX = new Background;
			
			m_levelManager = new LevelManager;
			m_currentLevel = m_levelManager.getCurrentRoom();
			
			m_player = new Player(Level.ROOM_DRAW_X + 3, Level.ROOM_DRAW_Y + m_currentLevel.m_tileHeight / 2);
			
			m_enemies = new FlxGroup;
			
			m_instructionText = new FlxText(0, 0, FlxG.width);
			m_instructionText.setFormat(null, 8, 0xffffb0, "center");
			m_instructionText.visible = false;
			
			m_healthBar = new HealthBar;
			m_failOverlay = new FailOverlay;
			m_failOverlay.visible = false;
			m_winOverlay = new WinOverlay;
			m_winOverlay.visible = false;
			
			m_muteText = new FlxText(FlxG.width -64, FlxG.height -16, 64);
			m_muteText.setFormat(null, 8, 0xffffb0, "center");
			m_muteText.text = s_myMute ? "[M] Unmute" : "[M] Mute";
			
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_backgroundGFX);
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
			s_layerOSD.add(m_healthBar);
			s_layerOSD.add(m_failOverlay);
			s_layerOSD.add(m_winOverlay);
			s_layerOSD.add(m_muteText);
			
			add(s_layerBackground);
			add(s_layerInScene);
			add(s_layerForeground);
			add(s_layerOSD);
			
			m_roomsTraversed = new Array;
			m_roomsTraversed.push(0);	// First room (0) already "traversed"
			m_gameTime = 0.0;
			
			m_sfxDoor = new FlxSound;
			m_sfxDoor.loadEmbedded(sndDoor);
			m_sfxPickUp = new FlxSound;
			m_sfxPickUp.loadEmbedded(sndPickUp);
			m_sfxDrop = new FlxSound;
			m_sfxDrop.loadEmbedded(sndDrop);
			m_sfxHurt1 = new FlxSound;
			m_sfxHurt1.loadEmbedded(sndHurt1);
			m_sfxHurt2 = new FlxSound;
			m_sfxHurt2.loadEmbedded(sndHurt2);
			
			FlxG.playMusic(sndMusic);
			if (s_myMute)
				FlxG.music.pause();
		}
		
		override public function update():void 
		{
			if (m_player.alive)
				m_gameTime += FlxG.elapsed;
				
			// Sound mute/unmute
			if (FlxG.keys.justPressed("M"))
			{
				s_myMute = !s_myMute;
				m_muteText.text = s_myMute ? "[M] Unmute" : "[M] Mute";
				if (s_myMute)
					FlxG.music.pause();
				else
					FlxG.music.resume();
			}
				
			// Obstacle collisions
			if (m_currentLevel.m_obstacle)
			{
				FlxG.collide(m_currentLevel.m_obstacle, m_player);
				FlxG.collide(m_currentLevel.m_obstacle, m_enemies);
			}
			
			// Player-enemy collisions
			if (FlxG.collide(m_enemies, m_player, enemyAttackAnim))
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
				m_healthBar.updateHP(m_player.health);
				
				if (!m_player.alive)
				{
					m_instructionText.visible = false;
					if (!m_winOverlay.visible)
					{
						m_failOverlay.setStats(m_gameTime, m_roomsTraversed.length);
						m_failOverlay.visible = true;
					}
				}
				else
				{
					if (!s_myMute)
					{
						if (Math.random() < 0.5)
							m_sfxHurt1.play();
						else
							m_sfxHurt2.play();
					}
				}
			}
			
			// Enemy-enemy collisions
			FlxG.collide(m_enemies, m_enemies);
				
			// Enemy targetting
			var activeLoot:Loot = null;
			for each (var lootTarget:Loot in m_currentLevel.m_pickUp_Loot)
			{
				if (lootTarget.alpha > 0.8)
				{
					activeLoot = lootTarget;
					
					// Check for exhaustion
					if (FlxG.overlap(activeLoot, m_enemies))
					{
						activeLoot.alpha = 0.75;
					}
				}
			}
			for each (var enemy:Enemy in m_enemies.members)
			{
				// Alertness check
				var alertRoll:Number = Math.random();
				if (alertRoll < 0.05)
				{
					if (!s_myMute && alertRoll < 0.01)
						enemy.m_sfxAlert.play();
					
					if (activeLoot)
					{
						enemy.setTargetPos(activeLoot.x + activeLoot.width/2, activeLoot.y + activeLoot.height - activeLoot.width/2);
					}
					else
					{
						enemy.setTargetPos(m_player.getCentreStandingPos().x, m_player.getCentreStandingPos().y);
					}
				}
			}
			
			// Item instructions
			if (m_player.alive)
			{
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
					
					if (m_player.m_hasLoot && !m_currentLevel.m_isExitRoom)
					{
						m_instructionText.text = "Press SPACE to drop LOOT";
						m_instructionText.visible = true;
						m_instructionTarget = m_player;
					}
					else
					{
						for each (var loot:Loot in m_currentLevel.m_pickUp_Loot)
						{
							if (FlxG.overlap(m_player, loot))
							{
								m_instructionText.text = "Press SPACE to pick up LOOT";
								m_instructionText.visible = true;
								m_instructionTarget = loot;
							}
						}
					}
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
							if (!s_myMute)
								m_sfxDoor.play();
						}
						else if (m_instructionTarget == m_currentLevel.m_door_SE)
						{
							nextRoom = m_currentLevel.m_neighbour_SE;
							m_player.x = Level.ROOM_DRAW_X - 2.0 * m_currentLevel.m_tileWidth;
							m_player.y = Level.ROOM_DRAW_Y + 3.0 * m_currentLevel.m_tileHeight;
							if (!s_myMute)
								m_sfxDoor.play();
						}
						else if (m_instructionTarget == m_currentLevel.m_door_SW)
						{
							nextRoom = m_currentLevel.m_neighbour_SW;
							m_player.x = Level.ROOM_DRAW_X + 2.0 * m_currentLevel.m_tileWidth;
							m_player.y = Level.ROOM_DRAW_Y + 3.0 * m_currentLevel.m_tileHeight;
							if (!s_myMute)
								m_sfxDoor.play();
						}
						else if (m_instructionTarget == m_currentLevel.m_door_NW)
						{
							nextRoom = m_currentLevel.m_neighbour_NW;
							m_player.x = Level.ROOM_DRAW_X + 2.0 * m_currentLevel.m_tileWidth;
							m_player.y = Level.ROOM_DRAW_Y + 6.0 * m_currentLevel.m_tileHeight;
							if (!s_myMute)
								m_sfxDoor.play();
						}
						else if (m_instructionTarget == m_player)
						{
							if (m_player.m_hasLoot)
							{
								// Drop loot
								var lootX:int = m_player.x;
								var lootY:int = m_player.y + m_player.height;
								var droppedLoot:Loot = new Loot(lootX, lootY, m_currentLevel.m_roomColour);
								droppedLoot.alpha = 1;
								m_currentLevel.m_pickUp_Loot.push(droppedLoot);
								s_layerInScene.add(droppedLoot);
								m_player.m_hasLoot = false;
								if (!s_myMute)
									m_sfxDrop.play();
							}
						}
						else
						{
							for (var lootLoop:int = 0; lootLoop < m_currentLevel.m_pickUp_Loot.length; lootLoop++)
							{
								if (m_instructionTarget == m_currentLevel.m_pickUp_Loot[lootLoop])
								{
									// Pick up loot
									s_layerInScene.remove(m_instructionTarget, true);
									m_currentLevel.m_pickUp_Loot.splice(lootLoop, 1);
									m_player.m_hasLoot = true;
									if (!s_myMute)
										m_sfxPickUp.play();
								}
							}
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
								
							if (m_currentLevel.m_obstacle)
								s_layerInScene.remove(m_currentLevel.m_obstacle, true);
								
							for each (var oldLoot:Loot in m_currentLevel.m_pickUp_Loot)
								s_layerInScene.remove(oldLoot, true);
							
							m_levelManager.changeCurrentRoom(nextRoom.m_roomIndex);	
							m_currentLevel = m_levelManager.getCurrentRoom();
							
							var roomIsRecorded:Boolean = false;
							for each (var roomID:int in m_roomsTraversed)
							{
								if (m_currentLevel.m_roomIndex == roomID)
								{
									roomIsRecorded = true;
									break;
								}
							}
							if (!roomIsRecorded)
								m_roomsTraversed.push(m_currentLevel.m_roomIndex);
							
							if (m_currentLevel.m_door_NE)
								s_layerBackground.add(m_currentLevel.m_door_NE);
							if (m_currentLevel.m_door_SE)
								s_layerForeground.add(m_currentLevel.m_door_SE);
							if (m_currentLevel.m_door_SW)
								s_layerForeground.add(m_currentLevel.m_door_SW);
							if (m_currentLevel.m_door_NW)
								s_layerBackground.add(m_currentLevel.m_door_NW);
								
							if (m_currentLevel.m_obstacle)
								s_layerInScene.add(m_currentLevel.m_obstacle);
							
							for each (var newLoot:Loot in m_currentLevel.m_pickUp_Loot)
								s_layerInScene.add(newLoot);
								
							// Populate
							for each (var oldEnemy:Enemy in m_enemies.members)
							{
								s_layerInScene.remove(oldEnemy, true);
							}
							
							m_enemies = new FlxGroup;
							for (var enemyLoop:int = 0; enemyLoop < m_currentLevel.m_enemyIDs.length; enemyLoop++)
							{
								var distToPlayerX:int = 0, distToPlayerY:int = 0;
								var enemyX:int, enemyY:int;
								while (distToPlayerX < 8 || distToPlayerY < 8)
								{
									enemyX = m_currentLevel.m_roomCentreX
												- (Math.random() - 0.5) * (Math.max(0, m_currentLevel.m_roomWidth - 16));
									enemyY = m_currentLevel.m_roomCentreY
												- (Math.random() - 0.5) * (Math.max(0, m_currentLevel.getMaxYForX(enemyX) * 2 - 16));
												
									distToPlayerX = (enemyX > m_player.x) ? (enemyX - m_player.x) : (m_player.x - enemyX);
									distToPlayerY = (enemyY > m_player.y) ? (enemyY - m_player.y) : (m_player.y - enemyY);
								}
								newEnemy = new Enemy(enemyX, enemyY, m_currentLevel.m_enemyIDs[enemyLoop]);
								m_enemies.add(newEnemy);
								
								if (m_currentLevel.m_obstacle && FlxG.overlap(newEnemy, m_currentLevel.m_obstacle))
								{
									var incX:Boolean = ((m_currentLevel.m_obstacle.x + m_currentLevel.m_obstacle.width / 2) < FlxG.width);
									while (FlxG.overlap(newEnemy, m_currentLevel.m_obstacle))
									{
										newEnemy.x = incX ? (newEnemy.x + 1) : (newEnemy.x - 1);
									}
								}
							}

							for each (var newEnemy:Enemy in m_enemies.members)
							{
								s_layerInScene.add(newEnemy);
							}
							
							if (m_currentLevel.m_isExitRoom)
							{
								// Made it to the exit, you win
								m_winOverlay.setStats(m_gameTime, m_roomsTraversed.length);
								m_winOverlay.visible = true;
								m_instructionText.visible = false;
								
								FlxG.music.stop();	// The silence is deafening
								m_backgroundGFX.visible = false;
							}
						}
					}
				}
			}
			else
			{
				// Dead, ESCAPE will proceed from here
				if (m_failOverlay.visible)
				{
					if (!m_instructionText.visible)
					{
						m_instructionText.text = "Press ESCAPE to RESTART";
						m_instructionText.visible = true;
					}
					
					if (FlxG.keys.justPressed("ESCAPE"))
					{
						FlxG.switchState( new PlayState() );
					}
				}
				else if (m_winOverlay.visible)
				{
					if (!m_instructionText.visible)
					{
						m_instructionText.text = "Press ESCAPE to RETURN";
						m_instructionText.visible = true;
					}
					
					if (FlxG.keys.justPressed("ESCAPE"))
					{
						FlxG.switchState( new MenuState() );
					}
				}
			}
			
			s_layerInScene.sort("y", ASCENDING);
			
			super.update();
		}
		
		private function enemyAttackAnim(enemy:Enemy, player:Player):void
		{
			switch (enemy.facing)
			{
				case FlxObject.RIGHT:
					enemy.play("Attack_R");
					break;
				case FlxObject.LEFT:
					enemy.play("Attack_L");
					break;
				case FlxObject.UP:
					enemy.play("Attack_U");
					break;
				case FlxObject.DOWN:
					enemy.play("Attack_D");
					break;
			}
			enemy.m_animDelayTimer = 0.1;
		}
	}
}