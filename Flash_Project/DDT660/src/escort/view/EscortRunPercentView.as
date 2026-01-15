package escort.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class EscortRunPercentView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _recordTxt:String;
      
      public function EscortRunPercentView()
      {
         super();
         this.x = 445;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.escort.countDownBg");
         this._txt = ComponentFactory.Instance.creatComponentByStylename("escort.countDownView.txt");
         this._recordTxt = LanguageMgr.GetTranslation("escort.game.runPercentTxt");
         this._txt.text = this._recordTxt + "--";
         addChild(this._bg);
         addChild(this._txt);
      }
      
      public function refreshView(posX:int) : void
      {
         var tmpDis:int = 22780 - posX;
         tmpDis = tmpDis < 0 ? 0 : tmpDis;
         var tmp:int = Math.ceil(tmpDis / 22500 * 10);
         if(Boolean(this._txt))
         {
            this._txt.text = this._recordTxt + tmp * 10 + "%";
         }
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

