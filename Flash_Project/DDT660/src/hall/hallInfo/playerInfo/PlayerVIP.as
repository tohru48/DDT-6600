package hall.hallInfo.playerInfo
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class PlayerVIP extends Sprite
   {
      
      private var _expSprite:Sprite;
      
      private var _mask:Sprite;
      
      private var _expBitmap:Bitmap;
      
      private var _expBitmapTip:ScaleFrameImage;
      
      private var _expText:FilterFrameText;
      
      private var _selfInfo:SelfInfo;
      
      private var _vipBtn:ScaleFrameImage;
      
      private var _levelNum:ScaleFrameImage;
      
      public function PlayerVIP()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._vipBtn.addEventListener(MouseEvent.CLICK,this.__showVipFrame);
         PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__isOpenBtn);
      }
      
      protected function __isOpenBtn(event:Event) : void
      {
         this._selfInfo = PlayerManager.Instance.Self;
         this.setVIPProgress();
         this.setVIPState();
      }
      
      private function initView() : void
      {
         this._expSprite = new Sprite();
         addChild(this._expSprite);
         this._expBitmap = ComponentFactory.Instance.creat("asset.hall.playerInfo.expVIP");
         this._expSprite.addChild(this._expBitmap);
         this._expBitmapTip = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.expVIP");
         addChild(this._expBitmapTip);
         this._expBitmapTip.alpha = 0;
         this.createMask();
         this._expText = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.expTxt");
         addChild(this._expText);
         this.setVIPProgress();
         this._vipBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.vipBtn");
         this._vipBtn.buttonMode = true;
         addChild(this._vipBtn);
         this._levelNum = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.vipLevel");
         this._levelNum.mouseEnabled = false;
         this._levelNum.visible = false;
         addChild(this._levelNum);
         this.setVIPState();
      }
      
      private function setVIPState() : void
      {
         if(this._selfInfo.IsVIP)
         {
            this._vipBtn.setFrame(2);
            this._levelNum.visible = true;
            this._levelNum.setFrame(this._selfInfo.VIPLevel);
         }
         else
         {
            this._vipBtn.setFrame(1);
         }
      }
      
      private function createMask() : void
      {
         this._mask = new Sprite();
         this._mask.graphics.beginFill(0,0);
         this._mask.graphics.drawRect(0,0,this._expBitmap.width,this._expBitmap.height);
         this._mask.graphics.endFill();
         addChild(this._mask);
         this._expSprite.mask = this._mask;
      }
      
      private function setVIPProgress() : void
      {
         var exp:int = 0;
         var now:int = 0;
         var max:int = 0;
         var curLevel:int = this._selfInfo.VIPLevel;
         if(curLevel == 12)
         {
            exp = ServerConfigManager.instance.VIPExpNeededForEachLv[11] - ServerConfigManager.instance.VIPExpNeededForEachLv[10];
            this.setProgress(1,1);
            this._expText.text = exp + "/" + exp;
         }
         else
         {
            now = this._selfInfo.VIPExp - ServerConfigManager.instance.VIPExpNeededForEachLv[curLevel - 1];
            max = ServerConfigManager.instance.VIPExpNeededForEachLv[curLevel] - ServerConfigManager.instance.VIPExpNeededForEachLv[curLevel - 1];
            this.setProgress(now,max);
            this._expText.text = now + "/" + max;
         }
         this.setExpTipData();
      }
      
      private function setExpTipData() : void
      {
         var need:int = 0;
         if(this._selfInfo.VIPLevel != 12 && this._selfInfo.IsVIP)
         {
            need = ServerConfigManager.instance.VIPExpNeededForEachLv[this._selfInfo.VIPLevel] - this._selfInfo.VIPExp;
            this._expBitmapTip.tipData = LanguageMgr.GetTranslation("ddt.vip.dueTime.tip",need,this._selfInfo.VIPLevel + 1);
         }
         else if(!this._selfInfo.IsVIP)
         {
            this._expBitmapTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.reduceVipExp");
         }
         else
         {
            this._expBitmapTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
         }
         if(!this._selfInfo.IsVIP && this._selfInfo.VIPExp <= 0)
         {
            this._expBitmapTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
         }
      }
      
      private function setProgress(now:int, max:int) : void
      {
         this._mask.x = -(this._expBitmap.width - now * this._expBitmap.width / max);
      }
      
      private function __showVipFrame(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
      }
      
      private function removeEvent() : void
      {
         this._vipBtn.removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
         PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__isOpenBtn);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

