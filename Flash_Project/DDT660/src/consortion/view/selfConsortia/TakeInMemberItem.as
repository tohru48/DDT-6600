package consortion.view.selfConsortia
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaApplyInfo;
   import ddt.data.player.BasePlayer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class TakeInMemberItem extends Sprite implements Disposeable
   {
      
      public var FightPower:int;
      
      public var Level:int;
      
      private var _selected:Boolean;
      
      private var _info:ConsortiaApplyInfo;
      
      private var _nameSelect:SelectedCheckButton;
      
      private var _name:FilterFrameText;
      
      private var _nameForVip:GradientText;
      
      private var _level:LevelIcon;
      
      private var _power:FilterFrameText;
      
      private var _check:TextButton;
      
      private var _agree:TextButton;
      
      private var _refuse:TextButton;
      
      public function TakeInMemberItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      override public function get height() : Number
      {
         return 30;
      }
      
      private function initView() : void
      {
         this._selected = false;
         this._nameSelect = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.select");
         this._name = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.name");
         this._level = ComponentFactory.Instance.creatCustomObject("consortion.takeIn.levelIcon");
         this._power = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.power");
         this._check = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.check");
         this._check.text = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
         this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.agree");
         this._agree.text = LanguageMgr.GetTranslation("tank.gametrainer.view.agree");
         this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.refuse");
         this._refuse.text = LanguageMgr.GetTranslation("tank.view.common.NPCPairingDialog.refuse");
         addChild(this._nameSelect);
         addChild(this._level);
         addChild(this._power);
         addChild(this._check);
         addChild(this._agree);
         addChild(this._refuse);
         this._level.setSize(LevelIcon.SIZE_SMALL);
      }
      
      private function initEvent() : void
      {
         this._nameSelect.addEventListener(MouseEvent.CLICK,this.__selectHandler);
         this._check.addEventListener(MouseEvent.CLICK,this.__checkHandler);
         this._agree.addEventListener(MouseEvent.CLICK,this.__agreeHandler);
         this._refuse.addEventListener(MouseEvent.CLICK,this.__refuseHandler);
      }
      
      private function removeEvent() : void
      {
         this._nameSelect.removeEventListener(MouseEvent.CLICK,this.__selectHandler);
         this._check.removeEventListener(MouseEvent.CLICK,this.__checkHandler);
         this._agree.removeEventListener(MouseEvent.CLICK,this.__agreeHandler);
         this._refuse.removeEventListener(MouseEvent.CLICK,this.__refuseHandler);
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this._nameSelect.selected = value;
      }
      
      public function get selected() : Boolean
      {
         return this._nameSelect.selected;
      }
      
      public function set info(value:ConsortiaApplyInfo) : void
      {
         this._info = value;
         if(this._info.IsVIP)
         {
            ObjectUtils.disposeObject(this._nameForVip);
            this._nameForVip = VipController.instance.getVipNameTxt(113,this._info.typeVIP);
            this._nameForVip.textSize = 16;
            this._nameForVip.x = this._name.x;
            this._nameForVip.y = this._name.y;
            this._nameForVip.text = this._info.UserName;
            this._nameSelect.addChild(this._nameForVip);
         }
         this._name.text = this._info.UserName;
         this._nameSelect.addChild(this._name);
         var p:BasePlayer = new BasePlayer();
         p.isOld = this._info.IsOld;
         p.IsVIP = this._info.IsVIP;
         PositionUtils.adaptNameStyle(p,this._name,this._nameForVip);
         this._level.setInfo(this._info.UserLevel,this._info.Repute,this._info.Win,this._info.Total,this._info.FightPower,this._info.Offer);
         this.Level = this._info.UserLevel;
         this._power.text = String(this._info.FightPower);
         this.FightPower = this._info.FightPower;
      }
      
      public function get info() : ConsortiaApplyInfo
      {
         return this._info;
      }
      
      private function __selectHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.selected = this._selected == true ? false : true;
      }
      
      private function __checkHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(this._info.UserID,PlayerManager.Instance.Self.ZoneID);
      }
      
      private function __agreeHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendConsortiaTryinPass(this._info.ID);
      }
      
      private function __refuseHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendConsortiaTryinDelete(this._info.ID);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._nameSelect = null;
         this._nameForVip = null;
         this._level = null;
         this._name = null;
         this._power = null;
         this._check = null;
         this._agree = null;
         this._refuse = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

