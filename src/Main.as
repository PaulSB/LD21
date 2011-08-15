package 
{
	import org.flixel.FlxGame;
	import states.MenuState;
	
	// Display properties
	[SWF(width = "720", height = "480", backgroundColor = "#000000")]
	// Prep preloader
	[Frame(factoryClass="Preloader")]
	
	/**
	 * Ludum Dare 21 -
	 * @author Paul S Burgess - 
	 */	
	public class Main extends FlxGame
	{
		public function Main()
		{			
			// Entry - invoke FlxGame constructor
			super(800, 600, MenuState, 1, 60, 30, true);
		}
	}
}