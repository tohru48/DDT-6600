package boguAdventure.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BoguAdventureHelpFrame extends Sprite implements Disposeable
   {
      
      private var _panel:ScrollPanel;
      
      private var _bg:Bitmap;
      
      private var _box:Sprite;
      
      private var _helpBtn:SelectedButton;
      
      private var _flag:Boolean;
      
      public function BoguAdventureHelpFrame()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._box = new Sprite();
         addChild(this._box);
         this._helpBtn = UICreatShortcut.creatAndAdd("boguAdventure.helpBtn",this);
         this._bg = UICreatShortcut.creatAndAdd("boguAdventure.helpBg",this._box);
         this._panel = UICreatShortcut.creatAndAdd("boguAdventure.helpPanel",this._box);
         var text:FilterFrameText = ComponentFactory.Instance.creat("boguAdventure.helpText");
         text.htmlText = LanguageMgr.GetTranslation("boguAdventure.view.helpText");
         this._panel.setView(text);
         var mask:Sprite = new Sprite();
         mask.graphics.beginFill(16777215);
         mask.graphics.drawRect(0,0,220,303);
         addChild(mask);
         PositionUtils.setPos(mask,"boguAdventure.helpMaskPos");
         this._box.mask = mask;
         this._box.y = -this._bg.height;
         this._flag = true;
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
      }
      
      private function __onHelpClick(e:MouseEvent) : void
      {
         TweenLite.killTweensOf(this._box);
         if(this._flag)
         {
            TweenLite.to(this._box,0.3,{"y":0});
            this._flag = false;
         }
         else
         {
            TweenLite.to(this._box,0.3,{"y":-this._bg.height});
            this._flag = true;
         }
      }
      
      public function dispose() : void
      {
         TweenLite.killTweensOf(this._box);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._box = null;
      }
   }
}

