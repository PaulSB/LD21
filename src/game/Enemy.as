package game 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../../data/textures/enemy.png')] private var imgEnemy:Class;
		
		//private const HORIZONTAL_WALK_SPEED:int = 30;
		//private const VERTICAL_WALK_SPEED:int = 20;
		private const WALK_SPEED:int = 20;
		
		private const NUM_ANIM_FRAMES_PER_DIRECTION:int = 1;
		// Pseudo-enum
		private const E_DIRECTION_LEFT:int = 0;
		private const E_DIRECTION_RIGHT:int = 1;
		private const E_DIRECTION_UP:int = 2;
		private const E_DIRECTION_DOWN:int = 3;
		
		public var m_spriteWidth:int;
		public var m_spriteHeight:int;
		
		private var m_targetPos:FlxPoint;
		private var m_hasTarget:Boolean;
		
		public function Enemy(xPos:int, yPos:int) 
		{
			super(xPos, yPos);
			
			loadGraphic(imgEnemy, true, false, 12, 16);
			m_spriteWidth = width;
			m_spriteHeight = height;
			
			addAnimation("Idle_L", [E_DIRECTION_LEFT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_R", [E_DIRECTION_RIGHT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_U", [E_DIRECTION_UP * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_D", [E_DIRECTION_DOWN * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			
			immovable = true;
			
			// Adjust collision rect
			offset.x = 3;
			offset.y = (height - height / 4);
			width -= offset.x * 2;
			height -= offset.y;
			
			m_hasTarget = false;
			m_targetPos = new FlxPoint;
		}
		
		override public function update():void 
		{
			// Move to target where one exists
			if (m_hasTarget)
			{
				//var centreX:Number = getCentreStandingPos().x;
				//var centreY:Number = getCentreStandingPos().y;
				
				var pathX:Number = m_targetPos.x - getCentreStandingPos().x;
				var pathY:Number = m_targetPos.y - getCentreStandingPos().y;
				var pathLength:Number = Math.sqrt(pathX * pathX + pathY * pathY);
				pathX /= pathLength;
				pathY /= pathLength;
				pathX *= WALK_SPEED;
				pathY *= WALK_SPEED;
				
				velocity.x = pathX;
				velocity.y = pathY;
			}
			
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
		
		public function getCentreStandingPos():FlxPoint
		{
			var ret:FlxPoint = new FlxPoint(x + width / 2.0, y + height - width / 4.0);
			return ret;
		}
		
		public function setTargetPos(targetX:Number, targetY:Number):void
		{
			m_targetPos.x = targetX;
			m_targetPos.y = targetY;
			m_hasTarget = true;
		}
	}
}