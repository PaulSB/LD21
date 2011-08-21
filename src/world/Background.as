package world 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 21/8/2011
	 */
	public class Background extends FlxGroup
	{
		[Embed(source = '../../data/textures/orb.png')] private var imgOrb:Class;
		[Embed(source = '../../data/textures/orb_mini.png')] private var imgOrbMini:Class;
		[Embed(source = '../../data/textures/orb_micro.png')] private var imgOrbMicro:Class;
		
		private const NUM_ORBS:int = 80;
		private const ORB_MAX_SPEED:int = 8;
		
		public function Background() 
		{
			for (var orbLoop:int = 0; orbLoop < NUM_ORBS; orbLoop++)
			{
				var newOrb:FlxSprite = new FlxSprite(Math.random() * FlxG.width, Math.random() * FlxG.height);
				
				var typeRoll:Number = Math.random();
				if (typeRoll < 0.4)
					newOrb.loadGraphic(imgOrb);
				else if (typeRoll < 0.7)
					newOrb.loadGraphic(imgOrbMini);
				else
					newOrb.loadGraphic(imgOrbMicro);
				newOrb.blend = "add";
				newOrb.alpha = 0.5 + Math.random() * 0.5;
				
				newOrb.x -= newOrb.width / 2;
				newOrb.y -= newOrb.height / 2;
				newOrb.velocity.x = (Math.random() - 0.5) * ORB_MAX_SPEED * 2;
				newOrb.velocity.y = (Math.random() - 0.5) * ORB_MAX_SPEED * 2;
				
				add(newOrb);
			}
		}
		
		override public function update():void 
		{
			super.update();
			 
			for each (var orb:FlxSprite in members)
			{
				if ( (orb.x < 0 - orb.width) || (orb.x > FlxG.width) || (orb.y < 0 - orb.height) || (orb.y > FlxG.height) )
				{
					// Recycle orbs:
					orb.x = Math.random() * FlxG.width;
					orb.y = Math.random() * FlxG.height;
					
					var typeRoll:Number = Math.random();
					if (typeRoll < 0.4)
						orb.loadGraphic(imgOrb);
					else if (typeRoll < 0.7)
						orb.loadGraphic(imgOrbMini);
					else
						orb.loadGraphic(imgOrbMicro);
					orb.blend = "add";
					orb.alpha = 0.5 + Math.random() * 0.5;
					
					orb.x -= orb.width / 2;
					orb.y -= orb.height / 2;
					orb.velocity.x = (Math.random() - 0.5) * ORB_MAX_SPEED * 2;
					orb.velocity.y = (Math.random() - 0.5) * ORB_MAX_SPEED * 2;
				}
			}
		}
	}
}