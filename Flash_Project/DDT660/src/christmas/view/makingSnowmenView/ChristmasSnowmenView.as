package christmas.view.makingSnowmenView
{
   import christmas.info.ChristmasSystemItemsInfo;
   import christmas.manager.ChristmasManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ChristmasSnowmenView extends Sprite implements Disposeable
   {
      
      private var _upGradeMc:MovieClip;
      
      private var _info:ChristmasSystemItemsInfo;
      
      public function ChristmasSnowmenView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._upGradeMc = ComponentFactory.Instance.creat("asset.snowmen.MC");
         this._upGradeMc.x = -39;
         this._upGradeMc.y = -32;
         this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
         this._upGradeMc.visible = false;
         addChild(this._upGradeMc);
      }
      
      private function init() : void
      {
         ChristmasManager.instance.expBar.initBar(ChristmasManager.instance.model.exp,ChristmasManager.instance.model.totalExp);
         this._upGradeMc.visible = false;
      }
      
      public function upGradeAction(info:ChristmasSystemItemsInfo) : void
      {
         this._info = info;
         if(!this._info.isUp)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("christmas.curInfo.upgradeExp",info.num));
            ChristmasManager.instance.expBar.initBar(ChristmasManager.instance.model.exp,ChristmasManager.instance.model.totalExp);
            return;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("christmas.curInfo.succe",info.snowNum));
         this._upGradeMc.visible = true;
         this._upGradeMc.gotoAndPlay(1);
         ChristmasManager.instance.expBar.initBar(ChristmasManager.instance.model.totalExp,ChristmasManager.instance.model.totalExp);
         addEventListener(Event.ENTER_FRAME,this.enterframeHander);
      }
      
      private function enterframeHander(e:Event) : void
      {
         if(this._upGradeMc.currentFrame == this._upGradeMc.totalFrames - 1)
         {
            this._upGradeMc.visible = false;
            this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
            SoundManager.instance.stop("170");
            SoundManager.instance.play("169");
            this.init();
            removeEventListener(Event.ENTER_FRAME,this.enterframeHander);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterframeHander);
         if(Boolean(this._upGradeMc))
         {
            this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
         }
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

