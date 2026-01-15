package game.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapShape;
   import ddt.manager.BitmapManager;
   import flash.display.Sprite;
   
   public class AchievNumShape extends Sprite implements Disposeable
   {
      
      private var _bitmapMgr:BitmapManager;
      
      private var _numShapes:Vector.<BitmapShape> = new Vector.<BitmapShape>();
      
      public function AchievNumShape()
      {
         super();
         visible = mouseChildren = mouseEnabled = false;
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function drawNum(num:int) : void
      {
         var shape:BitmapShape = this._numShapes.shift();
         while(shape != null)
         {
            ObjectUtils.disposeObject(shape);
            shape = this._numShapes.shift();
         }
         var numStr:String = num.toString();
         var len:int = numStr.length;
         for(var i:int = 0; i < len; i++)
         {
            shape = this._bitmapMgr.creatBitmapShape("asset.game.achiev.num" + numStr.substr(i,1));
            if(i > 0)
            {
               shape.x = this._numShapes[i - 1].x + this._numShapes[i - 1].width;
            }
            addChild(shape);
            this._numShapes.push(shape);
         }
         visible = true;
      }
   }
}

