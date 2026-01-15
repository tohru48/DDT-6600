package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossBuffItem extends Sprite implements Disposeable
   {
      
      private var _icon:Bitmap;
      
      private var _iconSprite:Sprite;
      
      private var _levelTxt:FilterFrameText;
      
      private var _tipBg:ScaleBitmapImage;
      
      private var _tipTitleTxt:FilterFrameText;
      
      private var _tipDescTxt:FilterFrameText;
      
      public function WorldBossBuffItem()
      {
         super();
         this.initView();
         this.updateInfo();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._icon = ComponentFactory.Instance.creatBitmap("worldBoss.attackBuff");
         this._iconSprite = new Sprite();
         this._iconSprite.addChild(this._icon);
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.buff.levelTxt");
         this._tipBg = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.newBuff.tipTxtBG");
         this._tipTitleTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.buff.tipTxt.title");
         this._tipDescTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.buff.tipTxt.desc");
         this.hideTip(null);
         addChild(this._iconSprite);
         addChild(this._levelTxt);
         addChild(this._tipBg);
         addChild(this._tipTitleTxt);
         addChild(this._tipDescTxt);
      }
      
      public function updateInfo() : void
      {
         var tmpLevel:int = WorldBossManager.Instance.bossInfo.myPlayerVO.buffLevel;
         this._levelTxt.text = tmpLevel.toString();
         var tmpEnhanceValue:int = WorldBossManager.Instance.bossInfo.myPlayerVO.buffInjure;
         this._tipTitleTxt.text = LanguageMgr.GetTranslation("worldboss.buffIcon.tip.title",tmpEnhanceValue);
         this._tipDescTxt.text = LanguageMgr.GetTranslation("worldboss.buffIcon.tip.desc",tmpEnhanceValue);
         this.visible = tmpLevel != 0 ? true : false;
      }
      
      private function addEvent() : void
      {
         this._iconSprite.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this._iconSprite.addEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
         WorldBossManager.Instance.addEventListener(Event.CHANGE,this.__update);
      }
      
      protected function __update(event:Event) : void
      {
         this.updateInfo();
      }
      
      private function showTip(event:MouseEvent) : void
      {
         this._tipBg.width = Math.max(this._tipBg.width,this._tipTitleTxt.textWidth + 30);
         this._tipBg.visible = true;
         this._tipTitleTxt.visible = true;
         this._tipDescTxt.visible = true;
      }
      
      private function hideTip(event:MouseEvent) : void
      {
         this._tipBg.visible = false;
         this._tipTitleTxt.visible = false;
         this._tipDescTxt.visible = false;
      }
      
      private function removeEvent() : void
      {
         this._iconSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this._iconSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
         WorldBossManager.Instance.removeEventListener(Event.CHANGE,this.__update);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._icon = null;
         this._levelTxt = null;
         this._tipBg = null;
         this._tipTitleTxt = null;
         this._tipDescTxt = null;
      }
   }
}

