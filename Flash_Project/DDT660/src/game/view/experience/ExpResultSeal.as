package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ExpResultSeal extends Sprite implements Disposeable
   {
      
      public static const WIN:String = "win";
      
      public static const LOSE:String = "lose";
      
      private var _luckyShapes:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private var _luckyExp:Boolean;
      
      private var _luckyOffer:Boolean;
      
      private var _bitmap:Bitmap;
      
      private var _starMc:MovieClip;
      
      private var _effectMc:MovieClip;
      
      private var _result:String;
      
      public function ExpResultSeal(str:String = "lose", luckyExp:Boolean = false, luckyOffer:Boolean = false)
      {
         super();
         this._result = str;
         this._luckyExp = luckyExp;
         this._luckyOffer = luckyOffer;
         this.init();
      }
      
      protected function init() : void
      {
         PositionUtils.setPos(this,"experience.ResultSealPos");
         if(this._result == WIN)
         {
            this._bitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewWin");
            this._starMc = ComponentFactory.Instance.creat("experience.WinStar");
            this._effectMc = ComponentFactory.Instance.creat("experience.WinEffectLight");
            addChild(this._starMc);
            addChildAt(this._effectMc,0);
         }
         else
         {
            this._bitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewLose");
         }
         addChild(this._bitmap);
         if(this._luckyExp)
         {
            this._luckyShapes.push(ComponentFactory.Instance.creat("asset.expView.LuckyExp"));
         }
         if(this._luckyOffer)
         {
            this._luckyShapes.push(ComponentFactory.Instance.creat("asset.expView.LuckyOffer"));
         }
         var left:Point = ComponentFactory.Instance.creat("experience.ResultSealLuckyLeft");
         for(var i:int = 0; i < this._luckyShapes.length; i++)
         {
            this._luckyShapes[i].x = left.x + i * 128;
            addChild(this._luckyShapes[i]);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._starMc) && Boolean(this._starMc.parent))
         {
            this._starMc.parent.removeChild(this._starMc);
         }
         if(Boolean(this._effectMc) && Boolean(this._effectMc.parent))
         {
            this._effectMc.parent.removeChild(this._effectMc);
         }
         this._starMc = null;
         this._effectMc = null;
         if(Boolean(this._bitmap))
         {
            ObjectUtils.disposeObject(this._bitmap);
            this._bitmap = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         var lucky:DisplayObject = this._luckyShapes.shift();
         while(lucky != null)
         {
            ObjectUtils.disposeObject(lucky);
            lucky = this._luckyShapes.shift();
         }
      }
   }
}

