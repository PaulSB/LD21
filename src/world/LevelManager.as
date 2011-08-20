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
			m_levels.push(new Level);
			m_numRooms = 1;
			
			m_currentRoom = 0;
		}
		
		public function getCurrentRoom():Level
		{
			return m_levels[m_currentRoom];
		}
	}
}