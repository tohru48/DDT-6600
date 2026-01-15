package treasure.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleUpDownImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TreasureHelpFrame extends Sprite implements Disposeable
   {
      
      private var _panel:ScrollPanel;
      
      private var _contents:MovieClip;
      
      private var _bg:ScaleUpDownImage;
      
      private var _box:Sprite;
      
      private var _btn:SelectedTextButton;
      
      private var _mask:Sprite;
      
      private var flag:Boolean;
      
      private var frameHead:Bitmap;
      
      public function TreasureHelpFrame()
      {
         super();
         this.init();
         this.initListener();
      }
      
      private function init() : void
      {
         this._box = new Sprite();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.treasure.helpFrame.BG");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("treasure.helpPanel");
         this._contents = ComponentFactory.Instance.creat("asset.treasure.help.contents");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("treasure.helpBtn");
         this.frameHead = ComponentFactory.Instance.creatBitmap("asset.treasure.help.frameUp");
         addChild(this._panel);
         this._box.addChild(this._bg);
         this.frameHead.x = 9;
         this.frameHead.y = 18;
         this._panel.setView(this._contents);
         this._box.addChild(this._panel);
         addChild(this._box);
         this._mask = new Sprite();
         this._mask.graphics.beginFill(16777215);
         this._mask.graphics.drawRect(0,0,282,270);
         PositionUtils.setPos(this._mask,"help.mask.pos");
         addChild(this._mask);
         this._box.mask = this._mask;
         this._box.y = -this._box.height;
         addChild(this._btn);
         addChild(this.frameHead);
         this.frameHead.visible = false;
         this.flag = true;
      }
      
      private function initListener() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this._btnClickHandler);
      }
      
      private function _btnClickHandler(e:MouseEvent) : void
      {
         this.frameHead.visible = true;
         TweenLite.killTweensOf(this._box);
         if(this.flag)
         {
            TweenLite.to(this._box,0.3,{"y":0});
            this.flag = false;
         }
         else
         {
            TweenLite.to(this._box,0.3,{
               "y":-this._bg.height + 20,
               "onComplete":this.outhandler
            });
            this.flag = true;
         }
      }
      
      private function outhandler() : void
      {
         this.frameHead.visible = false;
      }
      
      private function removeListener() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this._btnClickHandler);
      }
      
      public function dispose() : void
      {
         this.removeListener();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._mask))
         {
            ObjectUtils.disposeObject(this._mask);
         }
         this._mask = null;
         if(Boolean(this._btn))
         {
            ObjectUtils.disposeObject(this._btn);
         }
         this._btn = null;
         if(Boolean(this.frameHead))
         {
            ObjectUtils.disposeObject(this.frameHead);
         }
         this.frameHead = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this._contents))
         {
            ObjectUtils.disposeObject(this._contents);
         }
         this._contents = null;
         if(Boolean(this._box))
         {
            ObjectUtils.disposeObject(this._box);
         }
         this._box = null;
      }
   }
}

