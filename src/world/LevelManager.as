package world 
{
	import world.Level;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class LevelManager
	{
		private const MAP_DEPTH:int = 16;
		
		private var m_levels:Array;
		
		private var m_numRooms:int;
		private var m_currentRoom:int;
		
		public function LevelManager() 
		{
			m_levels = new Array;
			
			// Generate map
			var validMap:Boolean = false;
			while (!validMap)
			{
				var rooms:Array = new Array(MAP_DEPTH +1);
				var arrayLoop:int = 0, innerArrayLoop:int = 0;
				for (arrayLoop; arrayLoop < rooms.length; arrayLoop++)
				{
					rooms[arrayLoop] = new Array(MAP_DEPTH +1);
					for (innerArrayLoop = 0; innerArrayLoop < rooms[arrayLoop].length; innerArrayLoop++)
					{
						rooms[arrayLoop][innerArrayLoop] = false;
					}
				}
				
				var tierConnected:Boolean = false;
				
				// TIER 1
				rooms[0][0] = true;	// Start room
				
				// TIERS 2-MAX
				for (var tierLoop:int = 2; tierLoop <= MAP_DEPTH; tierLoop++)
				{
					tierConnected = false;
					while (!tierConnected)
					{
						for (var newRoomLoop:int = 0; newRoomLoop <= tierLoop -1; newRoomLoop++)
						{
							if (Math.random() > 0.5)
							{
								var rX:int = newRoomLoop, rY:int = (tierLoop -1) - newRoomLoop;
								rooms[rX][rY] = true;
								if ((rX > 0 && rooms[rX - 1][rY]) || (rY > 0 && rooms[rX][rY - 1]))
									tierConnected = true;
							}
						}
					}
				}
				
				// EXIT ROOM
				var numPossibleExits:int = MAP_DEPTH +1;
				var exitX:int, exitY:int;
				var exitIndex:int;
				tierConnected = false;
				var mapGenCounter:int = 0;		// Number of attempts to try find path to exit before doing-over
				while (!validMap && mapGenCounter < 16)
				{
					exitIndex = (Math.random() * (numPossibleExits+1));
					trace ("exit Index:", exitIndex);
					exitX = exitIndex;
					exitY = MAP_DEPTH - exitIndex;
					
					// Check if a (direct) path to start exists
					var pathX:int = exitX, pathY:int = exitY;
					while (pathX > 0 || pathY > 0)
					{
						var canTraverseX:Boolean = false, canTraverseY:Boolean = false;
						if (pathX > 0 && rooms[pathX - 1][pathY])
							canTraverseX = true;
						if (pathY > 0 && rooms[pathX][pathY - 1])
							canTraverseY = true;
							
						if (canTraverseX && canTraverseY)
						{
							if (Math.random() < 0.5)
								canTraverseX = false;
							else
								canTraverseY = false;
						}
						
						if (canTraverseX)
							pathX--;
						else if (canTraverseY)
							pathY--;
						else
							break;	// Path has broken down, no good
					}
					if (pathX == 0 && pathY == 0)
					{
						validMap = true;	// Valid path! hurrah!
					}
					
					mapGenCounter++;
				}
				
				exitIndex = exitY * rooms[0].length + exitX;
			}
			
			// Create levels
			var index:int = 0;
			var doorFlags:uint;
			for (var xLoop:int = 0; xLoop < rooms.length; xLoop++)
			{
				for (var yLoop:int = 0; yLoop < rooms[xLoop].length; yLoop++)
				{
					if (rooms[xLoop][yLoop])
					{
						doorFlags = Level.F_DIRECTION_NONE;
						if (yLoop > 0 && rooms[xLoop][yLoop -1])
							doorFlags |= Level.F_DIRECTION_NE;
						if (rooms[xLoop +1][yLoop])
							doorFlags |= Level.F_DIRECTION_SE;
						if (rooms[xLoop][yLoop +1])
							doorFlags |= Level.F_DIRECTION_SW;
						if (xLoop > 0 && rooms[xLoop -1][yLoop])
							doorFlags |= Level.F_DIRECTION_NW;
						
						index = yLoop * rooms[xLoop].length + xLoop;
						m_levels.push( new Level(index, doorFlags) );
						m_numRooms++;
					}
				}
			}
			// Exit:
			doorFlags = Level.F_DIRECTION_NONE;
			if (exitY > 0 && rooms[exitX][exitY -1])
				doorFlags |= Level.F_DIRECTION_NE;
			if (exitX > 0 && rooms[exitX -1][exitY])
				doorFlags |= Level.F_DIRECTION_NW;
			
			m_levels.push( new Level(exitIndex, doorFlags, true) );
			
			// Connect rooms
			for (xLoop = 0; xLoop < rooms.length; xLoop++)
			{
				for (yLoop = 0; yLoop < rooms[xLoop].length; yLoop++)
				{
					var thisRoom:Level = getRoomFromIndex(yLoop * rooms[xLoop].length + xLoop);
					if (thisRoom)
					{
						if (thisRoom.m_door_NE)
							thisRoom.m_neighbour_NE = getRoomFromIndex((yLoop -1) * rooms[xLoop].length + xLoop);
						if (thisRoom.m_door_SE)
							thisRoom.m_neighbour_SE = getRoomFromIndex(yLoop * rooms[xLoop +1].length + (xLoop +1));
						if (thisRoom.m_door_SW)
							thisRoom.m_neighbour_SW = getRoomFromIndex((yLoop +1) * rooms[xLoop].length + xLoop);
						if (thisRoom.m_door_NW)
							thisRoom.m_neighbour_NW = getRoomFromIndex(yLoop * rooms[xLoop -1].length + (xLoop -1));
					}
				}
			}
			// Exit:
			var exitRoom:Level = getRoomFromIndex(exitIndex);
			if (exitRoom.m_door_NE)
			{
				exitRoom.m_neighbour_NE = getRoomFromIndex((exitY -1) * rooms[exitX].length + exitX);
				exitRoom.m_neighbour_NE.m_neighbour_SW = exitRoom;
				
				exitRoom.m_neighbour_NE.m_doorFlags |= Level.F_DIRECTION_SW;
				exitRoom.m_neighbour_NE.setupDoors(exitRoom.m_neighbour_NE.m_doorFlags);
				
				exitRoom.m_door_NE = null;	// Disable door
			}
			if (exitRoom.m_door_NW)
			{
				exitRoom.m_neighbour_NW = getRoomFromIndex(exitY * rooms[exitX -1].length + (exitX -1));
				exitRoom.m_neighbour_NW.m_neighbour_SE = exitRoom;
				
				exitRoom.m_neighbour_NW.m_doorFlags |= Level.F_DIRECTION_SE;
				exitRoom.m_neighbour_NW.setupDoors(exitRoom.m_neighbour_NW.m_doorFlags);
				
				exitRoom.m_door_NW = null;	// Disable door
			}
			
			m_currentRoom = 0;
		}
		
		public function getCurrentRoom():Level
		{
			return getRoomFromIndex(m_currentRoom);
		}
		
		private function getRoomFromIndex(index:int):Level
		{
			for each (var lvl:Level in m_levels)
			{
				if (lvl.m_roomIndex == index)
					return lvl;
			}
			return null;
		}
		
		public function changeCurrentRoom(nextRoomIndex:int):void
		{
			m_currentRoom = nextRoomIndex;
		}
	}
}