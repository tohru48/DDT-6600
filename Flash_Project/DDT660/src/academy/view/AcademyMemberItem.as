package academy.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.AcademyManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class AcademyMemberItem extends Sprite implements Disposeable
   {
      
      private var _itembg:ScaleFrameImage;
      
      private var _line1:ScaleBitmapImage;
      
      private var _line2:ScaleBitmapImage;
      
      private var _line3:ScaleBitmapImage;
      
      private var _itemEffect:ScaleFrameImage;
      
      private var _OnlineIcon:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _fightPowerTxt:FilterFrameText;
      
      private var _levelIcon:LevelIcon;
      
      private var _info:AcademyPlayerInfo;
      
      private var _selected:Boolean;
      
      private var _index:int;
      
      public function AcademyMemberItem(index:int)
      {
         this._index = index;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._itembg = ComponentFactory.Instance.creatComponentByStylename("ddtacademy.rightview.signalLineBg");
         if(this._index % 2 == 0)
         {
            this._itembg.setFrame(1);
         }
         else
         {
            this._itembg.setFrame(2);
         }
         addChild(this._itembg);
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.formIine1");
         addChild(this._line1);
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.formIine2");
         addChild(this._line2);
         this._line3 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.formIine3");
         addChild(this._line3);
         this._itemEffect = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyMemberListView.itemEffect");
         addChild(this._itemEffect);
         this._itemEffect.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
         this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.fightPowerTxt");
         addChild(this._fightPowerTxt);
         this._OnlineIcon = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.state_icon");
         this._OnlineIcon.setFrame(2);
         addChild(this._OnlineIcon);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("academy.AcademyMemberItem.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseClick);
      }
      
      private function __onMouseClick(event:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._itemEffect.visible = false;
         }
      }
      
      private function __onMouseOver(event:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._itemEffect.visible = true;
         }
      }
      
      public function set isSelect(value:Boolean) : void
      {
         if(this._selected != value)
         {
            this._selected = value;
            this._itemEffect.visible = this._selected;
         }
      }
      
      public function get isSelect() : Boolean
      {
         return this._selected;
      }
      
      private function updateComponentPos() : void
      {
         if(this._info.info.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
         {
            this._fightPowerTxt.x = PositionUtils.creatPoint("academy.AcademyMemberListView").x;
            this._levelIcon.x = PositionUtils.creatPoint("academy.AcademyMemberListViewII").x;
         }
         else
         {
            this._fightPowerTxt.x = PositionUtils.creatPoint("academy.AcademyMemberListView").y;
            this._levelIcon.x = PositionUtils.creatPoint("academy.AcademyMemberListViewII").y;
         }
      }
      
      private function updateInfo() : void
      {
         var player:PlayerInfo = null;
         player = this.info.info;
         this._nameTxt.text = player.NickName;
         this._fightPowerTxt.text = String(player.FightPower);
         this._levelIcon.setInfo(player.Grade,player.Repute,player.WinCount,player.TotalCount,player.FightPower,player.Offer,true,false);
         if(player.playerState.StateID != PlayerState.OFFLINE)
         {
            this._OnlineIcon.setFrame(1);
         }
         else
         {
            this._OnlineIcon.setFrame(2);
         }
         if(player.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(181,player.typeVIP);
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._nameTxt.text;
            addChild(this._vipName);
            addChild(this._nameTxt);
            PositionUtils.adaptNameStyle(player,this._nameTxt,this._vipName);
         }
         else
         {
            addChild(this._nameTxt);
            this._nameTxt.visible = true;
            DisplayUtils.removeDisplay(this._vipName);
         }
      }
      
      public function set info(info:AcademyPlayerInfo) : void
      {
         this._info = info;
         this.updateInfo();
         this.updateComponentPos();
      }
      
      public function get info() : AcademyPlayerInfo
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseClick);
         if(Boolean(this._itemEffect))
         {
            ObjectUtils.disposeObject(this._itemEffect);
            this._itemEffect = null;
         }
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
         }
         if(Boolean(this._fightPowerTxt))
         {
            ObjectUtils.disposeObject(this._fightPowerTxt);
            this._fightPowerTxt = null;
         }
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(Boolean(this._OnlineIcon))
         {
            ObjectUtils.disposeObject(this._OnlineIcon);
            this._OnlineIcon = null;
         }
      }
   }
}

