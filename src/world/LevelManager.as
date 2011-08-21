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
			
			// Generate map - TO DO: procedural room node map generation (!)
			var index:int = 0;
			m_levels.push( new Level(index++, Level.F_DIRECTION_SW) );
			m_levels.push( new Level(index++, Level.F_DIRECTION_NE) );
			m_numRooms = index;
			
			m_levels[0].m_neighbour_SW = m_levels[1];
			m_levels[1].m_neighbour_NE = m_levels[0];
			
			m_currentRoom = 0;
		}
		
		public function getCurrentRoom():Level
		{
			return m_levels[m_currentRoom];
		}
		
		public function changeCurrentRoom(nextRoomIndex:int):void
		{
			m_currentRoom = nextRoomIndex;
		}
	}
}