package drgnBoat.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class DrgnBoatArriveCountDown extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _recordTxt:String;
      
      public function DrgnBoatArriveCountDown()
      {
         super();
         this.x = 445;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("drgnBoat.countDownBg");
         this._txt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.countDownView.txt");
         this._recordTxt = LanguageMgr.GetTranslation("drgnBoat.arriveCountDownTxt");
         this._txt.text = this._recordTxt + "--";
         addChild(this._bg);
         addChild(this._txt);
      }
      
      public function refreshView(posX:int, carSpeed:int) : void
      {
         var tmpDis:int = DrgnBoatMapView.LEN + DrgnBoatMapView.INIT_X - posX;
         tmpDis = tmpDis < 0 ? 0 : tmpDis;
         var differ:Number = tmpDis / carSpeed / 25;
         differ = differ < 0 ? 0 : differ;
         var minute:int = differ / 60;
         var second:int = differ % 60;
         var minStr:String = minute < 10 ? "0" + minute : minute.toString();
         var secStr:String = second < 10 ? "0" + second : second.toString();
         this._txt.text = this._recordTxt + minStr + ":" + secStr;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._txt = null;
         this._recordTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

