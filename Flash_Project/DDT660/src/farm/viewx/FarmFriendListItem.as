package farm.viewx
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.common.LevelIcon;
   import farm.FarmModelController;
   import farm.modelx.FramFriendStateInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import vip.VipController;
   
   public class FarmFriendListItem extends Sprite implements IListCell, Disposeable
   {
      
      private var _itemBG:Bitmap;
      
      private var _levelIcon:LevelIcon;
      
      private var _nameText:FilterFrameText;
      
      private var _stoleIcon:Bitmap;
      
      private var _feedIcon:Bitmap;
      
      private var _info:FramFriendStateInfo;
      
      private var _myColorMatrix_filter:ColorMatrixFilter;
      
      private var _vipName:GradientText;
      
      public function FarmFriendListItem()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public function get info() : FramFriendStateInfo
      {
         return this._info;
      }
      
      private function init() : void
      {
         buttonMode = true;
         this._myColorMatrix_filter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
         this._itemBG = ComponentFactory.Instance.creatBitmap("asset.farm.itemMouseOverBg");
         this._itemBG.visible = false;
         addChild(this._itemBG);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("farm.friendListItem.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._nameText = ComponentFactory.Instance.creat("farm.friendList.item.name");
         addChild(this._nameText);
         this._stoleIcon = ComponentFactory.Instance.creatBitmap("asset.farm.isStolenImage");
         this._stoleIcon.visible = false;
         addChild(this._stoleIcon);
         this._feedIcon = ComponentFactory.Instance.creatBitmap("asset.farm.friendList.feed");
         this._feedIcon.visible = false;
         addChild(this._feedIcon);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         addEventListener(MouseEvent.CLICK,this.__itemClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         removeEventListener(MouseEvent.CLICK,this.__itemClick);
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(StateManager.currentStateType == StateType.FARM && FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            FarmModelController.instance.exitFarm(PlayerManager.Instance.Self.ID);
         }
         FarmModelController.instance.goFarm(this._info.id,this._info.playerinfo.NickName);
      }
      
      private function __itemOver(event:MouseEvent) : void
      {
         this._itemBG.visible = true;
      }
      
      private function __itemOut(event:MouseEvent) : void
      {
         if(!this.isFriendSelected())
         {
            this._itemBG.visible = false;
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value;
         this.update();
      }
      
      private function update() : void
      {
         this._levelIcon.setInfo(this._info.playerinfo.Grade,this._info.playerinfo.Repute,this._info.playerinfo.WinCount,this._info.playerinfo.TotalCount,this._info.playerinfo.FightPower,this._info.playerinfo.Offer,true);
         if(this._info.playerinfo.IsVIP)
         {
            if(this._vipName == null)
            {
               this._vipName = VipController.instance.getVipNameTxt(100);
               addChild(this._vipName);
            }
            this._vipName.x = this._nameText.x;
            this._vipName.y = this._nameText.y;
            this._vipName.text = this._info.playerinfo.NickName;
            this._vipName.visible = true;
            this._nameText.visible = false;
         }
         else
         {
            if(Boolean(this._vipName))
            {
               this._vipName.visible = false;
            }
            this._nameText.visible = true;
         }
         this._nameText.text = this._info.playerinfo.NickName;
         if(FarmModelController.instance.model.SelectIndex == 0)
         {
            this._feedIcon.visible = false;
            this._stoleIcon.visible = this._info.isStolen;
         }
         else
         {
            this._stoleIcon.visible = false;
            this._feedIcon.visible = this._info.isFeed;
         }
         if(this._info.playerinfo.playerState.StateID == 0)
         {
            this.filters = [this._myColorMatrix_filter];
         }
         else
         {
            this.filters = null;
         }
         if(this.isFriendSelected())
         {
            this._itemBG.visible = true;
         }
         else
         {
            this._itemBG.visible = false;
         }
      }
      
      private function isFriendSelected() : Boolean
      {
         if(FarmModelController.instance.model.currentFarmerName == this._info.playerinfo.NickName)
         {
            return true;
         }
         return false;
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._itemBG = null;
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         this._nameText = null;
         this._stoleIcon = null;
         this._feedIcon = null;
         this._myColorMatrix_filter = null;
      }
   }
}

