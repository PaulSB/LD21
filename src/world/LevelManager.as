package world 
{
	import world.Level;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class LevelManager
	{
		private var m_levels:Array;
		
		private var m_numRooms:int;
		private var m_currentRoom:int;
		
		public function LevelManager() 
		{
			m_levels = new Array;
			
			// Generate map
			//var roomsX:Array = new Array(9);
			//var roomsY:Array = new Array(9);
			var rooms:Array = new Array(9);
			var arrayLoop:int = 0;
			for (arrayLoop; arrayLoop < rooms.length; arrayLoop++)
			{
				rooms[arrayLoop] = new Array(false, false, false, false, false, false, false, false, false);
			}
			
			// TIER 1
			rooms[0][0] = true;	// Start room
			// TIER 2
			var tierConnected:Boolean = false;
			while (!tierConnected)
			{
				if (Math.random() > 0.5)
				{
					rooms[0][1] = true;
					tierConnected = true;
				}
				if (Math.random() > 0.5)
				{
					rooms[1][0] = true;
					tierConnected = true;
				}
			}
			// TIER 3
			tierConnected = false;
			while (!tierConnected)
			{
				if (Math.random() > 0.5)
				{
					rooms[0][2] = true;
					if (rooms[0][1])
						tierConnected = true;
				}
				if (Math.random() > 0.5)
				{
					rooms[1][1] = true;
					tierConnected = true;
				}
				if (Math.random() > 0.5)
				{
					rooms[2][0] = true;
					if (rooms[1][0])
						tierConnected = true;
				}
			}
			
			// Create levels
			var index:int = 0;
			for (var xLoop:int = 0; xLoop < rooms.length; xLoop++)
			{
				for (var yLoop:int = 0; yLoop < rooms[xLoop].length; yLoop++)
				{
					if (rooms[xLoop][yLoop])
					{
						var doorFlags:uint = Level.F_DIRECTION_NONE;
						if (yLoop > 0 && rooms[xLoop][yLoop -1])
							doorFlags |= Level.F_DIRECTION_NE;
						if (rooms[xLoop +1][yLoop])
							doorFlags |= Level.F_DIRECTION_SE;
						if (rooms[xLoop][yLoop +1])
							doorFlags |= Level.F_DIRECTION_SW;
						if (xLoop > 0 && rooms[xLoop -1][yLoop])
							doorFlags |= Level.F_DIRECTION_NW;
						
						index = yLoop * rooms[xLoop].length + xLoop;
						m_levels.push( new Level(index++, doorFlags) );
						m_numRooms++;
					}
				}
			}
			
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