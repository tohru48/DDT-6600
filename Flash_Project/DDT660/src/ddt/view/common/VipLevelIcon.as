package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class VipLevelIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const SIZE_BIG:int = 0;
      
      public static const SIZE_SMALL:int = 1;
      
      private static const LEVEL_ICON_CLASSPATH:String = "asset.vipIcon.vipLevel_";
      
      private var _seniorIcon:ScaleFrameImage;
      
      private var _level:int = 1;
      
      private var _type:int = 0;
      
      private var _isVip:Boolean = false;
      
      private var _vipExp:int = 0;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:String;
      
      private var _size:int;
      
      public function VipLevelIcon()
      {
         super();
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipGapV = 10;
         this._tipGapH = 10;
         this._tipDirctions = "7,4,6,5";
         this._size = SIZE_SMALL;
         this._seniorIcon = ComponentFactory.Instance.creatComponentByStylename("core.SeniorVipLevelIcon");
         ShowTipManager.Instance.addTip(this);
      }
      
      public function setInfo(info:BasePlayer, isShowTip:Boolean = true, forVIPFrame:Boolean = false) : void
      {
         var need:int = 0;
         this._level = info.VIPLevel;
         this._isVip = info.IsVIP;
         this._vipExp = info.VIPExp;
         if(info.ID == PlayerManager.Instance.Self.ID)
         {
            if(isShowTip)
            {
               buttonMode = !forVIPFrame;
               if(this._isVip)
               {
                  if(info.VIPLevel < 12)
                  {
                     need = ServerConfigManager.instance.VIPExpNeededForEachLv[this._level] - info.VIPExp;
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradDays",need,this._level + 1);
                  }
                  else
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
                  }
               }
               else if(info.VIPExp > 0)
               {
                  this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue");
               }
               else
               {
                  this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
               }
            }
            else
            {
               mouseEnabled = false;
               mouseChildren = false;
            }
            if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPExp == 0)
            {
               this._level = 0;
            }
            if(!forVIPFrame)
            {
               addEventListener(MouseEvent.CLICK,this.__showVipFrame);
            }
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
            buttonMode = false;
            if(isShowTip)
            {
               this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.otherVipTip",info.VIPLevel);
            }
            else
            {
               mouseEnabled = false;
               mouseChildren = false;
            }
         }
         this._type = info.typeVIP;
         this.updateIcon();
      }
      
      private function __showVipFrame(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
      }
      
      private function updateIcon() : void
      {
         DisplayUtils.removeDisplay(this._seniorIcon);
         if(this._size == SIZE_SMALL)
         {
            if(this._isVip || this._vipExp > 0)
            {
               this._seniorIcon.setFrame(this._level + 14);
               addChild(this._seniorIcon);
            }
            else
            {
               this._seniorIcon.setFrame(14);
               addChild(this._seniorIcon);
            }
         }
         else if(this._size == SIZE_BIG)
         {
            if(this._isVip || this._vipExp > 0)
            {
               this._seniorIcon.setFrame(this._level + 1);
               addChild(this._seniorIcon);
            }
            else
            {
               this._seniorIcon.setFrame(1);
               addChild(this._seniorIcon);
            }
         }
      }
      
      public function setSize(size:int) : void
      {
         this._size = size;
         this.updateIcon();
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value as String;
      }
      
      public function set tipDirctions(value:String) : void
      {
      }
      
      public function set tipGapV(value:int) : void
      {
      }
      
      public function set tipGapH(value:int) : void
      {
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(w:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
         ObjectUtils.disposeObject(this._seniorIcon);
         this._seniorIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

