package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class WinRate extends Sprite implements Disposeable
   {
      
      private var _win:int;
      
      private var _total:int;
      
      private var _bg:Bitmap;
      
      private var rate_txt:FilterFrameText;
      
      public function WinRate($win:int, $total:int)
      {
         super();
         this._win = $win;
         this._total = $total;
         this.init();
         this.setRate(this._win,this._total);
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.core.leveltip.WinRateBg");
         this.rate_txt = ComponentFactory.Instance.creat("core.WinRateTxt");
         addChild(this._bg);
         addChild(this.rate_txt);
      }
      
      public function setRate($win:int, $total:int) : void
      {
         this._win = $win;
         this._total = $total;
         var rate:Number = this._total > 0 ? this._win / this._total * 100 : 0;
         this.rate_txt.text = rate.toFixed(2) + "%";
      }
      
      public function dispose() : void
      {
         if(Boolean(this.rate_txt))
         {
            ObjectUtils.disposeObject(this.rate_txt);
         }
         this.rate_txt = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

