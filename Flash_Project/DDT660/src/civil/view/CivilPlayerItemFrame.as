package civil.view
{
   import civil.CivilEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class CivilPlayerItemFrame extends Sprite implements Disposeable
   {
      
      private var _info:CivilPlayerInfo;
      
      private var _level:int = 1;
      
      private var _levelIcon:LevelIcon;
      
      private var _isSelect:Boolean;
      
      private var _selectEffect:Scale9CornerImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _stateIcon:ScaleFrameImage;
      
      private var _bg:ScaleFrameImage;
      
      private var _line1:ScaleBitmapImage;
      
      private var _line2:ScaleBitmapImage;
      
      private var _selected:Boolean = false;
      
      private var _index:int;
      
      public function CivilPlayerItemFrame(index:int)
      {
         buttonMode = true;
         this._index = index;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.rightview.signalLineBg");
         if(this._index % 2 == 0)
         {
            this._bg.setFrame(1);
         }
         else
         {
            this._bg.setFrame(2);
         }
         addChild(this._bg);
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.formIine1");
         addChild(this._line1);
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.formIine2");
         addChild(this._line2);
         this._selectEffect = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.rightview.signalLine.selected");
         addChild(this._selectEffect);
         this._selectEffect.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.SelectBGPlayerName");
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("ddtcivil.levelIcon_list");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._stateIcon = ComponentFactory.Instance.creat("ddtcivil.state_icon");
         addChild(this._stateIcon);
      }
      
      public function set info(info:CivilPlayerInfo) : void
      {
         this._info = info;
         this.upView();
         this.addEvent();
      }
      
      public function get info() : CivilPlayerInfo
      {
         return this._info;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandle);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandle);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function __offerChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["isVip"]))
         {
            this.upView();
         }
      }
      
      private function __clickHandle(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CivilEvent(CivilEvent.SELECT_CLICK_ITEM,this));
      }
      
      private function __overHandle(e:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._selectEffect.visible = true;
         }
      }
      
      private function __outHandle(e:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._selectEffect.visible = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(val:Boolean) : void
      {
         if(this._selected != val)
         {
            this._selected = val;
            this._selectEffect.visible = this._selected;
         }
      }
      
      private function upView() : void
      {
         this._nameTxt.text = this._info.info.NickName;
         if(this._info.info.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(181,this._info.info.typeVIP);
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._nameTxt.text;
            addChild(this._vipName);
            addChild(this._nameTxt);
            PositionUtils.adaptNameStyle(this._info.info,this._nameTxt,this._vipName);
         }
         else
         {
            addChild(this._nameTxt);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._levelIcon.setInfo(this._info.info.Grade,this._info.info.Repute,this._info.info.WinCount,this._info.info.TotalCount,this._info.info.FightPower,this._info.info.Offer,true,false);
         if(this._info.info.Sex)
         {
            this._stateIcon.setFrame(Boolean(this._info.info.playerState.StateID) ? 1 : 3);
         }
         else
         {
            this._stateIcon.setFrame(Boolean(this._info.info.playerState.StateID) ? 2 : 3);
         }
      }
      
      override public function get height() : Number
      {
         if(this._bg == null)
         {
            return 0;
         }
         return this._bg.y + this._bg.height;
      }
      
      public function dispose() : void
      {
         this._info = null;
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._selectEffect))
         {
            ObjectUtils.disposeObject(this._selectEffect);
         }
         this._selectEffect = null;
         ObjectUtils.disposeObject(this._stateIcon);
         this._stateIcon = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

