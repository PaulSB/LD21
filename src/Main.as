package 
{
	import org.flixel.FlxGame;
	import states.MenuState;
	
	// Display properties
	[SWF(width = "720", height = "480", backgroundColor = "#000000")]
	// Prep preloader
	[Frame(factoryClass="Preloader")]
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */	
	public class Main extends FlxGame
	{
		public function Main()
		{			
			// Entry - invoke FlxGame constructor
			super(180, 120, MenuState, 4, 60, 30, true);
		}
	}
}