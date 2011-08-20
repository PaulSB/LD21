package game 
{
	import org.flixel.FlxSprite;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../../data/textures/enemy.png')] private var imgEnemy:Class;
		
		private const NUM_ANIM_FRAMES_PER_DIRECTION:int = 1;
		// Pseudo-enum
		private const E_DIRECTION_LEFT:int = 0;
		private const E_DIRECTION_RIGHT:int = 1;
		private const E_DIRECTION_UP:int = 2;
		private const E_DIRECTION_DOWN:int = 3;
		
		public function Enemy(xPos:int, yPos:int) 
		{
			super(xPos, yPos);
			
			loadGraphic(imgEnemy, true, false, 12, 16);
			
			addAnimation("Idle_L", [E_DIRECTION_LEFT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_R", [E_DIRECTION_RIGHT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_U", [E_DIRECTION_UP * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_D", [E_DIRECTION_DOWN * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
		}
		
		override public function update():void 
		{
			// Animate
			if (velocity.x > 0)
			{
				// Right
				play("Idle_R");
			}
			else if (velocity.x < 0)
			{
				// Left
				play("Idle_L");
			}
			else if (velocity.y > 0)
			{
				// Down
				play("Idle_D");
			}
			else if (velocity.y < 0)
			{
				// Down
				play("Idle_U");
			}
			
			super.update();
		}
	}
}