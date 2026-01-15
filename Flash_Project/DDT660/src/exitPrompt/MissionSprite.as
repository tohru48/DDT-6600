package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.TiledImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class MissionSprite extends Sprite implements Disposeable
   {
      
      public var oldHeight:int;
      
      private const BG_X:int = 4;
      
      public const BG_Y:int = -25;
      
      private const BG_WIDTH:int = 290;
      
      private var _arr:Array;
      
      public function MissionSprite(arr:Array)
      {
         super();
         this._arr = arr;
         this._init(this._arr);
      }
      
      private function _init(arr:Array) : void
      {
         var i:int = 0;
         var bg:Sprite = null;
         var textFiele0:FilterFrameText = null;
         var textFiele1:FilterFrameText = null;
         var line:TiledImage = null;
         for(i = 0; i < arr.length; i++)
         {
            textFiele0 = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText0");
            textFiele0.text = arr[i][0] as String;
            textFiele0.y = textFiele0.height * i * 3 / 2 - 6;
            addChild(textFiele0);
            textFiele1 = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText1");
            textFiele1.text = arr[i][1] as String;
            textFiele1.y = textFiele1.height * i * 3 / 2 - 4;
            addChild(textFiele1);
            line = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.item.line");
            line.y = textFiele0.height * i * 3 / 2 + 16;
            addChild(line);
         }
         this.oldHeight = height;
         bg = new Sprite();
         bg.graphics.beginFill(6899489,1);
         bg.graphics.drawRoundRect(0,0,this.BG_WIDTH,35,5,5);
         bg.graphics.endFill();
         addChild(bg);
         bg.x = this.BG_X;
         bg.y = this.BG_Y;
         bg.height = this.height - this.BG_Y;
         setChildIndex(bg,0);
      }
      
      public function get content() : Array
      {
         return this._arr;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

