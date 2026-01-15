package dayActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class DayAcBar extends MovieClip implements Disposeable
   {
      
      private var _expBarTxt:FilterFrameText;
      
      private var _bar:MovieClip;
      
      private var _ground:Bitmap;
      
      private var _crruFrame:int = 1;
      
      private var _newFrame:int = 0;
      
      public function DayAcBar()
      {
         super();
         this.initView();
      }
      
      public function initView() : void
      {
         this._ground = ComponentFactory.Instance.creat("day.activity.barBack");
         addChild(this._ground);
         this._bar = ComponentFactory.Instance.creat("day.activity.bar");
         this._bar.x = 17;
         this._bar.y = 9;
         this._bar.gotoAndStop(this._crruFrame);
         addChild(this._bar);
         this._expBarTxt = ComponentFactory.Instance.creatComponentByStylename("day.activityView.right.expBarTxt");
         this._expBarTxt.text = "0";
         addChild(this._expBarTxt);
      }
      
      public function initBar(num:int) : void
      {
         this._newFrame = num;
         if(num == 0)
         {
            this._bar.gotoAndStop(1);
            this._expBarTxt.text = String(this._newFrame);
            return;
         }
         if(this._newFrame >= 100)
         {
            this._expBarTxt.text = String(this._newFrame);
            this._bar.gotoAndStop(100);
            return;
         }
         this._bar.gotoAndStop(this._newFrame);
         this._expBarTxt.text = String(this._newFrame);
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

