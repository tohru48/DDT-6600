package ringStation.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import ringStation.model.BattleFieldListItemInfo;
   import vip.VipController;
   
   public class BattleFieldsItem extends Sprite implements Disposeable
   {
      
      private var _fightIconBg:Bitmap;
      
      private var _fightIcon:Bitmap;
      
      private var _infoText:FilterFrameText;
      
      private var _index:int;
      
      private var _nickNameText:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _battleInfo:BattleFieldListItemInfo;
      
      private var _playerInfo:PlayerInfo;
      
      private var msgID:String = "1";
      
      public function BattleFieldsItem($index:int)
      {
         super();
         this._index = $index;
         this.init();
      }
      
      private function init() : void
      {
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.battleField.itemInfo");
         addChild(this._infoText);
         this._nickNameText = ComponentFactory.Instance.creatComponentByStylename("ringStation.view.battleItem.nickNameText");
         this._nickNameText.mouseEnabled = true;
         this._nickNameText.addEventListener(TextEvent.LINK,this.__nickNameLinkHandler);
         addChild(this._nickNameText);
      }
      
      public function update(info:BattleFieldListItemInfo) : void
      {
         this._battleInfo = info;
         if(Boolean(this._fightIconBg))
         {
            ObjectUtils.disposeObject(this._fightIconBg);
         }
         this._fightIconBg = null;
         if(Boolean(this._fightIcon))
         {
            ObjectUtils.disposeObject(this._fightIcon);
         }
         this._fightIcon = null;
         if(this._battleInfo.DareFlag)
         {
            this._fightIcon = ComponentFactory.Instance.creatBitmap("ringStation.view.swordIcon");
         }
         else
         {
            this._fightIcon = ComponentFactory.Instance.creatBitmap("ringStation.view.shieldIcon");
         }
         this._fightIconBg = ComponentFactory.Instance.creat("ringStation.view.fightIconBg");
         addChild(this._fightIconBg);
         addChild(this._fightIcon);
         var newString:String = "";
         newString = this._index == 0 ? LanguageMgr.GetTranslation("ringStation.view.battleFieldsView.itemInfoNew") : "";
         this._infoText.htmlText = newString + this.updateText(this._battleInfo);
         this._nickNameText.htmlText = "<u><a href=\'event:battleTxt\'>" + this.setUerNameLength(this._battleInfo.UserName) + "</a></u>";
         if(this.msgID == "1" || this.msgID == "2" || this.msgID == "5")
         {
            this._nickNameText.x = 103;
         }
         else
         {
            this._nickNameText.x = 79;
         }
         if(this._index == 0)
         {
            this._nickNameText.x += 27;
         }
         this.findPlayer(info.UserName);
      }
      
      private function findPlayer(playerName:String) : void
      {
         this._playerInfo = new PlayerInfo();
         if(playerName == PlayerManager.Instance.Self.NickName)
         {
            this._playerInfo = PlayerManager.Instance.Self;
         }
         else
         {
            this._playerInfo = PlayerManager.Instance.findPlayerByNickName(this._playerInfo,playerName);
         }
         if(Boolean(this._playerInfo.ID) && Boolean(this._playerInfo.Style))
         {
            this.updateTxt();
         }
         else
         {
            SocketManager.Instance.out.sendItemEquip(playerName,true);
            this._playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         }
      }
      
      private function __playerInfoChange(event:PlayerPropertyEvent) : void
      {
         this._playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         this.updateTxt();
      }
      
      private function updateTxt() : void
      {
         var tempName:String = null;
         tempName = this.setUerNameLength(this._playerInfo.NickName);
         if(this._playerInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(104,this._playerInfo.typeVIP);
            this._vipName.addEventListener(MouseEvent.CLICK,this.__nickNameLinkHandler);
            this._vipName.textField.autoSize = "none";
            this._vipName.textField.setTextFormat(this._nickNameText.getTextFormat());
            this._vipName.textField.defaultTextFormat = this._nickNameText.getTextFormat();
            this._vipName.buttonMode = true;
            this._vipName.textSize = 14;
            this._vipName.x = this._nickNameText.x;
            this._vipName.y = this._nickNameText.y;
            this._vipName.htmlText = "<u><a href=\'event:battleTxt\'>" + tempName + "</a></u>";
            addChild(this._vipName);
            PositionUtils.adaptNameStyle(this._playerInfo,this._nickNameText,this._vipName);
         }
      }
      
      private function updateText(info:BattleFieldListItemInfo) : String
      {
         if(info.DareFlag)
         {
            this.msgID = info.SuccessFlag ? "1" : "2";
            if(info.SuccessFlag && info.Level == 0)
            {
               this.msgID = "5";
            }
         }
         else
         {
            this.msgID = info.SuccessFlag ? "3" : "4";
            if(!info.SuccessFlag && info.Level == 0)
            {
               this.msgID = "6";
            }
         }
         return LanguageMgr.GetTranslation("ringStation.view.battleFieldsView.itemInfo" + this.msgID,"             ",info.Level);
      }
      
      private function setUerNameLength(userName:String) : String
      {
         if(userName.length > 7)
         {
            userName = userName.substring(0,5) + "..";
         }
         return userName;
      }
      
      private function __nickNameLinkHandler(evt:Event) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._playerInfo))
         {
            PlayerInfoViewControl.view(this._playerInfo);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._fightIconBg))
         {
            ObjectUtils.disposeObject(this._fightIconBg);
            this._fightIconBg = null;
         }
         if(Boolean(this._fightIcon))
         {
            ObjectUtils.disposeObject(this._fightIcon);
            this._fightIcon = null;
         }
         if(Boolean(this._infoText))
         {
            ObjectUtils.disposeObject(this._infoText);
            this._infoText = null;
         }
         if(Boolean(this._nickNameText))
         {
            this._nickNameText.removeEventListener(TextEvent.LINK,this.__nickNameLinkHandler);
            ObjectUtils.disposeObject(this._nickNameText);
         }
         if(Boolean(this._vipName))
         {
            this._vipName.removeEventListener(MouseEvent.CLICK,this.__nickNameLinkHandler);
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
         }
      }
   }
}

