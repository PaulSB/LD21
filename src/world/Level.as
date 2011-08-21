package world 
{
	import game.Loot;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	//import org.flixel.FlxU;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class Level
	{
		[Embed(source = '../../data/textures/tile_floor.png')] private var imgTileFloor:Class;
		[Embed(source = '../../data/textures/door.png')] private var imgDoor:Class;
		[Embed(source = '../../data/textures/table.png')] private var imgTable:Class;
		
		private const ROOM_TILE_SIZE:int = 9;
		public static const ROOM_DRAW_X:int = FlxG.width / 2 - 9;
		public static const ROOM_DRAW_Y:int = 12;
		
		private const NUM_DOOR_FRAMES_PER_DIRECTION:int = 1;
		
		// flags
		public static const F_DIRECTION_NONE:uint = 0;
		public static const F_DIRECTION_NE:uint = 1;
		public static const F_DIRECTION_SE:uint = 2;
		public static const F_DIRECTION_SW:uint = 4;
		public static const F_DIRECTION_NW:uint = 8;
		// psuedo-enum
		public static const E_DIRECTION_NE:uint = 0;
		public static const E_DIRECTION_SE:uint = 1;
		public static const E_DIRECTION_SW:uint = 2;
		public static const E_DIRECTION_NW:uint = 3;
		
		public var m_neighbour_NE:Level = null;
		public var m_neighbour_SE:Level = null;
		public var m_neighbour_SW:Level = null;
		public var m_neighbour_NW:Level = null;
		
		public var m_floor:FlxGroup;
		public var m_doors:FlxGroup;
		public var m_door_NE:FlxSprite = null;
		public var m_door_SE:FlxSprite = null;
		public var m_door_SW:FlxSprite = null;
		public var m_door_NW:FlxSprite = null;
		public var m_obstacle:FlxSprite = null;
		
		// Pick-ups
		public var m_pickUp_Loot:Array;
		
		public var m_roomIndex:int;
		public var m_doorFlags:uint = F_DIRECTION_NONE;
		public var m_roomColour:uint;
		public var m_isExitRoom:Boolean = false;
		public var m_numEnemies:int = 0;
		
		public var m_tileWidth:int = 0;
		public var m_tileHeight:int = 0;
		
		public var m_roomWidth:Number = 0;
		public var m_roomHeight:Number = 0;
		public var m_roomCentreX:Number = 0;
		public var m_roomCentreY:Number = 0;
		
		public function Level(roomIndex:int, doorFlags:uint = 0, isExit:Boolean = false)
		{
			m_roomIndex = roomIndex;
			
			// Create level
			var r:Number = Math.max(0.1, (Math.random() * 255.0));
			var g:Number = Math.max(0.1, (Math.random() * 255.0));
			var b:Number = Math.max(0.1, (Math.random() * 255.0));
			m_roomColour = 0xff000000 + (r << 16) + (g << 8) + b;
			if (roomIndex == 0)
				m_roomColour = 0xffffffff;
				
			if (isExit)
			{
				m_isExitRoom = true;				
				m_roomColour = 0xff000000;
			}
			
			m_floor = new FlxGroup;
			
			var x:int = ROOM_DRAW_X, y:int = ROOM_DRAW_Y;
			for (var j:int = 0; j <= ROOM_TILE_SIZE; ++j)
			{
				for (var i:int = 0; i < ROOM_TILE_SIZE; ++i)
				{
					var tile:FlxSprite = new FlxSprite(x,y);
					tile.loadGraphic(imgTileFloor);
					tile.color = m_roomColour;
					m_floor.add(tile);
					
					m_tileWidth = tile.width;
					m_tileHeight = tile.height;
					x += m_tileWidth / 2;
					y += m_tileHeight / 2;
				}
				
				x = ROOM_DRAW_X - j * tile.width / 2;
				y = ROOM_DRAW_Y + j * tile.height / 2;
			}
			
			m_roomWidth = m_tileWidth * ROOM_TILE_SIZE;
			m_roomHeight = m_tileHeight * ROOM_TILE_SIZE;
			m_roomCentreX = ROOM_DRAW_X + (m_tileWidth / 2.0);
			m_roomCentreY = ROOM_DRAW_Y + (m_roomHeight / 2.0);
			
			setupDoors(doorFlags);
			
			m_pickUp_Loot = new Array;
			if (m_roomIndex > 0 && !m_isExitRoom)
			{
				if (Math.random() < 0.25)
				{
					var lootX:int = m_roomCentreX + (Math.random() - 0.5) * (Math.max(0, m_roomWidth - 24));
					var lootY:int = m_roomCentreY + (Math.random() - 0.5) * (Math.max(0, getMaxYForX(lootX) * 2 - 24));
					m_pickUp_Loot.push( new Loot(lootX - 9.0, lootY - 9.0, m_roomColour) );
				}
				
				if (Math.random() < 0.3)
				{
					var obstacleX:int = m_roomCentreX + (Math.random() - 0.5) * 30;//(Math.max(0, m_roomWidth - 24));
					var obstacleY:int = m_roomCentreY + (Math.random() - 0.5) * 20;// (Math.max(0, getMaxYForX(lootX) * 2 - 24));
					m_obstacle = new FlxSprite(obstacleX, obstacleY);
					m_obstacle.loadGraphic(imgTable);
					m_obstacle.x -= m_obstacle.width / 2;
					m_obstacle.y -= m_obstacle.height / 2;
					// Adjust collision rect:
					m_obstacle.offset.y = 8;
					m_obstacle.height -= m_obstacle.offset.y;
					m_obstacle.y += m_obstacle.offset.y;
					m_obstacle.immovable = true;
					m_obstacle.color = m_roomColour;
				}
			}
		}
		
		public function IsInLevelBounds(xPos:Number, yPos:Number):Boolean
		{
			var maxXforY:Number = getMaxXForY(yPos);
			var maxYforX:Number = getMaxYForX(xPos);
			
			// Result
			if ((xPos - 4 <= m_roomCentreX - maxXforY) || (xPos + 4 >= m_roomCentreX + maxXforY))
			{
				return false;
			}
			else if ((yPos - 4 <= m_roomCentreY - maxYforX) || (yPos + 4 >= m_roomCentreY + maxYforX))
			{
				return false;
			}
			
			return true;
		}
		
		public function getMaxXForY(yPos:Number):Number
		{
			var maxXforY:Number;
			var offsetY:Number;
			if (yPos < m_roomCentreY)
			{
				offsetY = m_roomCentreY - yPos;
			}
			else
			{
				offsetY = yPos - m_roomCentreY;
			}
			maxXforY = (1 - offsetY / (m_roomHeight / 2.0)) * (m_roomWidth / 2.0);
			
			return maxXforY;
		}
		
		public function getMaxYForX(xPos:Number):Number
		{
			var maxYforX:Number;
			var offsetX:Number;
			if (xPos < m_roomCentreX)
			{
				offsetX = m_roomCentreX - xPos;
			}
			else
			{
				offsetX = xPos - m_roomCentreX;
			}
			maxYforX = (1 - offsetX / (m_roomWidth / 2.0)) * (m_roomHeight / 2.0);
			
			return maxYforX;
		}
		
		public function setupDoors(doorFlags:uint):void
		{
			// Clear any old doors
			m_door_NE = m_door_SE = m_door_SW = m_door_NW = null;
			
			m_doorFlags = doorFlags;
			
			var doorX:Number, doorY:Number;
			if (doorFlags & F_DIRECTION_NE)
			{
				doorX = ROOM_DRAW_X + 2.0 * m_tileWidth;
				doorY = ROOM_DRAW_Y + 3.0 * m_tileHeight;
				m_door_NE = new FlxSprite(doorX, doorY);
				m_door_NE.loadGraphic(imgDoor, true, false, 18, 32);
				m_door_NE.color = m_roomColour;
				m_door_NE.y -= m_door_NE.height;
				// Adjust collision rect:
				m_door_NE.offset.y = (m_door_NE.height - m_door_NE.width);
				m_door_NE.height -= m_door_NE.offset.y;
				m_door_NE.y += m_door_NE.offset.y;
				
				m_door_NE.addAnimation("closed", [E_DIRECTION_NE * NUM_DOOR_FRAMES_PER_DIRECTION +0]);
				m_door_NE.play("closed");
			}
			if (doorFlags & F_DIRECTION_SE)
			{
				doorX = ROOM_DRAW_X + 2.0 * m_tileWidth;
				doorY = ROOM_DRAW_Y + 7.0 * m_tileHeight;
				m_door_SE = new FlxSprite(doorX, doorY);
				m_door_SE.loadGraphic(imgDoor, true, false, 18, 32);
				m_door_SE.color = m_roomColour;
				m_door_SE.y -= m_door_SE.height;
				// Adjust collision rect:
				m_door_SE.offset.y = (m_door_SE.height - m_door_SE.width);
				m_door_SE.height -= m_door_SE.offset.y;
				m_door_SE.y += m_door_SE.offset.y;
				
				m_door_SE.addAnimation("closed", [E_DIRECTION_SE * NUM_DOOR_FRAMES_PER_DIRECTION +0]);
				m_door_SE.play("closed");
			}
			if (doorFlags & F_DIRECTION_SW)
			{
				doorX = ROOM_DRAW_X - 2.0 * m_tileWidth;
				doorY = ROOM_DRAW_Y + 7.0 * m_tileHeight;
				m_door_SW = new FlxSprite(doorX, doorY);
				m_door_SW.loadGraphic(imgDoor, true, false, 18, 32);
				m_door_SW.color = m_roomColour;
				m_door_SW.y -= m_door_SW.height;
				// Adjust collision rect:
				m_door_SW.offset.y = (m_door_SW.height - m_door_SW.width);
				m_door_SW.height -= m_door_SW.offset.y;
				m_door_SW.y += m_door_SW.offset.y;
				
				m_door_SW.addAnimation("closed", [E_DIRECTION_SW * NUM_DOOR_FRAMES_PER_DIRECTION +0]);
				m_door_SW.play("closed");
			}
			if (doorFlags & F_DIRECTION_NW)
			{
				doorX = ROOM_DRAW_X - 2.0 * m_tileWidth;
				doorY = ROOM_DRAW_Y + 3.0 * m_tileHeight;
				m_door_NW = new FlxSprite(doorX, doorY);
				m_door_NW.loadGraphic(imgDoor, true, false, 18, 32);
				m_door_NW.color = m_roomColour;
				m_door_NW.y -= m_door_NW.height;
				// Adjust collision rect:
				m_door_NW.offset.y = (m_door_NW.height - m_door_NW.width);
				m_door_NW.height -= m_door_NW.offset.y;
				m_door_NW.y += m_door_NW.offset.y;
				
				m_door_NW.addAnimation("closed", [E_DIRECTION_NW * NUM_DOOR_FRAMES_PER_DIRECTION +0]);
				m_door_NW.play("closed");
			}
		}
	}
}