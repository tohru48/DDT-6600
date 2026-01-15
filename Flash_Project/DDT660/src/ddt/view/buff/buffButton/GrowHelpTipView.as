package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GrowHelpTipView extends Sprite
   {
      
      private static const BTNNUM:int = 4;
      
      private var _viewBg:ScaleBitmapImage;
      
      private var _buffArray:Vector.<BuffButton>;
      
      private var _openBtn:Vector.<TextButton>;
      
      public function GrowHelpTipView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._buffArray = new Vector.<BuffButton>();
         this._openBtn = new Vector.<TextButton>();
      }
      
      private function initView() : void
      {
         this._viewBg = ComponentFactory.Instance.creatComponentByStylename("bagBuffer.tipView.bg");
         this._viewBg.height = 160;
         addChild(this._viewBg);
      }
      
      private function addOpenButton() : void
      {
         var i:int = 0;
         for(i = 0; i < BTNNUM; i++)
         {
            this._openBtn.push(ComponentFactory.Instance.creatComponentByStylename("bagBuffer.growHelp.openBtn"));
            this._openBtn[i].text = LanguageMgr.GetTranslation("ddt.bagandinfo.buffBuf");
            this._openBtn[i].addEventListener(MouseEvent.CLICK,this.__onClick);
            PositionUtils.setPos(this._openBtn[i],"growhelp.buffPos" + String(i + 1));
            this._openBtn[i].x += 50;
            this._openBtn[i].y -= 4;
            addChild(this._openBtn[i]);
            PositionUtils.setPos(this._buffArray[i],"growhelp.buffPos" + String(i + 1));
         }
      }
      
      protected function __onClick(event:MouseEvent) : void
      {
         var length:int = int(this._openBtn.length);
         for(var i:int = 0; i < length; i++)
         {
            if(this._openBtn[i] == event.currentTarget)
            {
               this._buffArray[i].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            }
         }
      }
      
      public function addBuff(buffArray:Array) : void
      {
         var length:int = int(buffArray.length);
         for(var i:int = 0; i < length; i++)
         {
            this._buffArray.push(buffArray[i]);
            addChild(buffArray[i]);
         }
         this.addOpenButton();
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._viewBg))
         {
            this._viewBg.dispose();
            this._viewBg = null;
         }
         for(var i:int = 0; i < this._buffArray.length; i++)
         {
            this._buffArray[i].dispose();
            this._buffArray[i] = null;
         }
         this._buffArray = null;
         for(var j:int = 0; j < this._openBtn.length; j++)
         {
            this._openBtn[j].dispose();
            this._openBtn[j] = null;
         }
         this._openBtn = null;
      }
      
      public function get viewBg() : ScaleBitmapImage
      {
         return this._viewBg;
      }
   }
}

