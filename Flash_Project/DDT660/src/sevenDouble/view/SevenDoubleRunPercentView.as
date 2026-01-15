package sevenDouble.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SevenDoubleRunPercentView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _recordTxt:String;
      
      public function SevenDoubleRunPercentView()
      {
         super();
         this.x = 476;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.countDownBg");
         this._txt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.countDownView.txt");
         this._txt.x = 4;
         this._recordTxt = LanguageMgr.GetTranslation("sevenDouble.game.runPercentTxt");
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

