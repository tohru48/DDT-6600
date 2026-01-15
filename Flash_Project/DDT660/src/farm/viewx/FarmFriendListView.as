package farm.viewx
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.*;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FramFriendStateInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import road7th.data.DictionaryEvent;
   import trainer.data.ArrowType;
   
   public class FarmFriendListView extends Sprite implements Disposeable
   {
      
      private var _list:ListPanel;
      
      private var _switchAsset:ScaleFrameImage;
      
      private var isOpen:Boolean = true;
      
      private var _listBG:ScaleBitmapImage;
      
      private var _listBound:ScaleBitmapImage;
      
      private var _hBox:HBox;
      
      private var _poultryBtn:SelectedTextButton;
      
      private var _stealBtn:SelectedTextButton;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _tabBitmap:Bitmap;
      
      private var _switchTween:TweenLite;
      
      public function FarmFriendListView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._listBG = ComponentFactory.Instance.creatComponentByStylename("farm.friendListBg");
         addChild(this._listBG);
         this._listBound = ComponentFactory.Instance.creatComponentByStylename("farm.friendListBound");
         addChild(this._listBound);
         this._switchAsset = ComponentFactory.Instance.creatComponentByStylename("farm.listSwitch");
         this._switchAsset.buttonMode = true;
         if(this.isOpen)
         {
            this._switchAsset.setFrame(1);
         }
         addChild(this._switchAsset);
         this._tabBitmap = ComponentFactory.Instance.creat("asset.farm.selectTab");
         addChild(this._tabBitmap);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("farm.farmFriendListPanel.btnHbox");
         addChild(this._hBox);
         this._stealBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmFriendListPanel.stealSelectBtn");
         this._stealBtn.text = LanguageMgr.GetTranslation("farm.friendListPanel.stealBtnText");
         this._hBox.addChild(this._stealBtn);
         this._poultryBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmFriendListPanel.poultrySelectBtn");
         this._poultryBtn.text = LanguageMgr.GetTranslation("farm.friendListPanel.poultryText");
         this._hBox.addChild(this._poultryBtn);
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._stealBtn);
         this._selectedButtonGroup.addSelectItem(this._poultryBtn);
         this._selectedButtonGroup.selectIndex = 0;
         FarmModelController.instance.model.SelectIndex = this._selectedButtonGroup.selectIndex;
         this._hBox.arrange();
         this._list = ComponentFactory.Instance.creat("asset.farm.farmFriendListPanel");
         this._list.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._list);
         this._list.list.updateListView();
         this.switchView();
         this.update();
      }
      
      private function initEvent() : void
      {
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.__onBtnGroupChange);
         PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__friendlistHandler);
         FarmModelController.instance.addEventListener(FarmEvent.FRIEND_INFO_READY,this.__infoReady);
         FarmModelController.instance.addEventListener(FarmEvent.FRIENDLIST_UPDATESTOLEN,this.__updateFriendListStolen);
         this._switchAsset.addEventListener(MouseEvent.CLICK,this.__onClick);
         this._switchAsset.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._switchAsset.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__playerRemove);
      }
      
      protected function __onBtnGroupChange(event:Event) : void
      {
         SoundManager.instance.playButtonSound();
         FarmModelController.instance.model.SelectIndex = this._selectedButtonGroup.selectIndex;
         FarmModelController.instance.updateSetupFriendListLoader();
      }
      
      protected function __playerRemove(event:DictionaryEvent) : void
      {
         var player:FriendListPlayer = event.data as FriendListPlayer;
         FarmModelController.instance.model.friendStateList.remove(player.ID);
         this.update();
      }
      
      protected function __outHandler(event:MouseEvent) : void
      {
         this._switchAsset.filters = null;
      }
      
      protected function __overHandler(event:MouseEvent) : void
      {
         this._switchAsset.filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      protected function __friendlistHandler(event:Event) : void
      {
         this.update();
      }
      
      protected function __infoReady(event:FarmEvent) : void
      {
         this.update();
      }
      
      protected function __updateFriendListStolen(event:FarmEvent) : void
      {
         var itemInfo:FarmFriendListItem = null;
         var stateInfo:FramFriendStateInfo = null;
         var friendPlayer:FramFriendStateInfo = FarmModelController.instance.model.friendStateListStolenInfo[FarmModelController.instance.model.currentFarmerId];
         for each(itemInfo in this._list.list.cell)
         {
            if(Boolean(itemInfo.info))
            {
               if(itemInfo.info.id == friendPlayer.id)
               {
                  itemInfo.setCellValue(friendPlayer);
                  break;
               }
            }
         }
         for each(stateInfo in (this._list.list.model as VectorListModel).elements)
         {
            if(stateInfo.id == friendPlayer.id)
            {
               stateInfo.landStateVec = friendPlayer.landStateVec;
               stateInfo.isFeed = friendPlayer.isFeed;
               break;
            }
         }
      }
      
      private function __onClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.switchView();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK6))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_IM);
         }
      }
      
      private function switchView() : void
      {
         var tempInt:int = this.isOpen ? 2 : 1;
         this._switchAsset.setFrame(tempInt);
         if(this.isOpen)
         {
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":952,
               "ease":Sine.easeInOut
            });
         }
         else
         {
            FarmModelController.instance.updateSetupFriendListLoader();
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":773,
               "ease":Sine.easeInOut
            });
         }
         this.isOpen = tempInt == 1 ? true : false;
      }
      
      private function update() : void
      {
         var stateInfo:FramFriendStateInfo = null;
         var player:PlayerInfo = null;
         this._list.vectorListModel.clear();
         for each(stateInfo in FarmModelController.instance.model.friendStateList)
         {
            player = stateInfo.playerinfo;
            if(Boolean(player))
            {
               this._list.vectorListModel.insertElementAt(stateInfo,this.getInsertIndex(player));
            }
         }
         this._list.list.updateListView();
      }
      
      private function getInsertIndex(info:PlayerInfo) : int
      {
         var tempInfo:PlayerInfo = null;
         var tempIndex:int = 0;
         var tempArray:Array = this._list.vectorListModel.elements;
         if(tempArray.length == 0)
         {
            return 0;
         }
         for(var i:int = tempArray.length - 1; i >= 0; i--)
         {
            tempInfo = (tempArray[i] as FramFriendStateInfo).playerinfo;
            if(!(info.IsVIP && !tempInfo.IsVIP))
            {
               if(!info.IsVIP && tempInfo.IsVIP)
               {
                  return i + 1;
               }
               if(info.IsVIP == tempInfo.IsVIP)
               {
                  if(info.Grade <= tempInfo.Grade)
                  {
                     return i + 1;
                  }
                  tempIndex = i - 1;
               }
            }
         }
         return tempIndex < 0 ? 0 : tempIndex;
      }
      
      private function removeEvent() : void
      {
         this._selectedButtonGroup.removeEventListener(Event.CHANGE,this.__onBtnGroupChange);
         PlayerManager.Instance.removeEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__friendlistHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.FRIEND_INFO_READY,this.__infoReady);
         FarmModelController.instance.removeEventListener(FarmEvent.FRIENDLIST_UPDATESTOLEN,this.__updateFriendListStolen);
         this._switchAsset.removeEventListener(MouseEvent.CLICK,this.__onClick);
         this._switchAsset.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._switchAsset.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE,this.__playerRemove);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._switchTween))
         {
            this._switchTween.kill();
         }
         this._switchTween = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._switchAsset))
         {
            ObjectUtils.disposeObject(this._switchAsset);
         }
         this._switchAsset = null;
         if(Boolean(this._tabBitmap))
         {
            ObjectUtils.disposeObject(this._tabBitmap);
         }
         this._tabBitmap = null;
         if(Boolean(this._selectedButtonGroup))
         {
            ObjectUtils.disposeObject(this._selectedButtonGroup);
         }
         this._selectedButtonGroup = null;
         if(Boolean(this._poultryBtn))
         {
            ObjectUtils.disposeObject(this._poultryBtn);
         }
         this._poultryBtn = null;
         if(Boolean(this._stealBtn))
         {
            ObjectUtils.disposeObject(this._stealBtn);
         }
         this._stealBtn = null;
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         if(Boolean(this._listBG))
         {
            ObjectUtils.disposeObject(this._listBG);
         }
         this._listBG = null;
         if(Boolean(this._listBound))
         {
            ObjectUtils.disposeObject(this._listBound);
         }
         this._listBound = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

