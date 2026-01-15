package im
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.CMFriendInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   
   public class CMFriendList extends Sprite implements Disposeable
   {
      
      public static const LIST_MAX_NUM:int = 5;
      
      private var _list:VBox;
      
      private var _CMFriendArray:Array;
      
      private var _CMFriendItemArray:Array;
      
      private var _title:IMListItemView;
      
      private var _titleInfo:FriendListPlayer;
      
      private var _titleII:IMListItemView;
      
      private var _titleInfoII:FriendListPlayer;
      
      private var _currentTitleInfo:FriendListPlayer;
      
      private var _playCurrentPage:int;
      
      private var _playDDTListTotalPage:int;
      
      private var _unplayCurrentPage:int;
      
      private var _unplayDDTListTotalPage:int;
      
      private var _upPageBtn:BaseButton;
      
      private var _downPageBtn:BaseButton;
      
      private var _InviteBlogBtn:TextButton;
      
      private var _switchBtn1:SelectedCheckButton;
      
      private var _switchBtn2:SelectedCheckButton;
      
      private var _currentCMFInfo:CMFriendInfo;
      
      public function CMFriendList()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.CMFriendList");
         addChild(this._list);
         this._CMFriendItemArray = [];
         this._upPageBtn = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.upPageBtn");
         addChild(this._upPageBtn);
         this._downPageBtn = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.downPageBtn");
         addChild(this._downPageBtn);
         this._InviteBlogBtn = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendList.InviteBlogBtn");
         this._InviteBlogBtn.text = LanguageMgr.GetTranslation("tank.view.im.InviteBtn");
         addChild(this._InviteBlogBtn);
         this._switchBtn1 = ComponentFactory.Instance.creatComponentByStylename("core.switchBtn1");
         this._switchBtn1.selected = SharedManager.Instance.autoSnsSend;
         if(!this._switchBtn1.selected)
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData1");
         }
         else
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData2");
         }
         addChild(this._switchBtn1);
         this._switchBtn2 = ComponentFactory.Instance.creatComponentByStylename("core.switchBtn2");
         this._switchBtn2.selected = SharedManager.Instance.allowSnsSend;
         if(!this._switchBtn2.selected)
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData1");
         }
         else
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData2");
         }
         addChild(this._switchBtn2);
         if(!(PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog()))
         {
            this._InviteBlogBtn.visible = false;
            this._upPageBtn.x = 22;
            this._downPageBtn.x = 100;
            this._switchBtn1.x = 186;
            this._switchBtn2.x = 214;
         }
         this.initTitle();
         this.updatePageBtnState();
      }
      
      private function initTitle() : void
      {
         var pos:Point = null;
         this._titleInfo = new FriendListPlayer();
         this._titleInfo.type = 0;
         this._titleInfo.titleType = 0;
         this._titleInfo.titleIsSelected = false;
         this._titleInfo.titleNumText = "";
         this._titleInfo.titleText = LanguageMgr.GetTranslation("im.CMFriendList.title");
         this._title = new IMListItemView();
         pos = ComponentFactory.Instance.creatCustomObject("IM.CMFriendList.titlePos");
         this._title.setCellValue(this._titleInfo);
         this._title.x = pos.x;
         this._title.y = pos.y;
         addChild(this._title);
         this._titleInfoII = new FriendListPlayer();
         this._titleInfoII.type = 0;
         this._titleInfoII.titleType = 1;
         this._titleInfoII.titleIsSelected = false;
         this._titleInfoII.titleNumText = "";
         this._titleInfoII.titleText = LanguageMgr.GetTranslation("im.CMFriendList.titleII");
         this._titleII = new IMListItemView();
         this._titleII.setCellValue(this._titleInfoII);
         addChild(this._titleII);
         this._currentTitleInfo = this._titleInfo;
         if(Boolean(PlayerManager.Instance.CMFriendList))
         {
            this.creatItem();
            this.updateList();
         }
         else
         {
            this.updateListPos();
         }
         if(PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog())
         {
            this._titleII.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._title.addEventListener(MouseEvent.CLICK,this.__titleClick);
         this._titleII.addEventListener(MouseEvent.CLICK,this.__titleClick);
         this._upPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._downPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._InviteBlogBtn.addEventListener(MouseEvent.CLICK,this.__inviteBolg);
         this._switchBtn1.addEventListener(MouseEvent.CLICK,this.__switchBtn1Click);
         this._switchBtn2.addEventListener(MouseEvent.CLICK,this.__switchBtn2Click);
      }
      
      private function __pageBtnClick(event:MouseEvent) : void
      {
         if(event.currentTarget == this._upPageBtn)
         {
            if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
            {
               --this._playCurrentPage;
            }
            else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
            {
               --this._unplayCurrentPage;
            }
         }
         else if(event.currentTarget == this._downPageBtn)
         {
            if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
            {
               ++this._playCurrentPage;
            }
            else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
            {
               ++this._unplayCurrentPage;
            }
         }
         this.updateItem();
         SoundManager.instance.play("008");
         this.updatePageBtnState();
      }
      
      private function __inviteBolg(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ExternalInterface.available)
         {
            ExternalInterface.call("showInviteBox",PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.Self.ID);
         }
      }
      
      private function updatePageBtnState() : void
      {
         var currentPage:int = 0;
         var totalPlay:int = 0;
         this._upPageBtn.enable = this._downPageBtn.enable = false;
         if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
         {
            currentPage = this._playCurrentPage;
            totalPlay = this._playDDTListTotalPage;
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            currentPage = this._unplayCurrentPage;
            totalPlay = this._unplayDDTListTotalPage;
         }
         if(totalPlay > 1)
         {
            if(currentPage > 0 && currentPage < totalPlay - 1)
            {
               this._upPageBtn.enable = this._downPageBtn.enable = true;
            }
            else if(currentPage <= 0 && currentPage < totalPlay - 1)
            {
               this._downPageBtn.enable = true;
            }
            else if(currentPage > 0 && currentPage >= totalPlay - 1)
            {
               this._upPageBtn.enable = true;
            }
         }
      }
      
      private function __titleClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if((event.currentTarget as IMListItemView).getCellValue() == this._currentTitleInfo)
         {
            this._currentTitleInfo.titleIsSelected = !this._currentTitleInfo.titleIsSelected;
         }
         else
         {
            this._currentTitleInfo.titleIsSelected = false;
            this._currentTitleInfo = (event.currentTarget as IMListItemView).getCellValue();
            this._currentTitleInfo.titleIsSelected = true;
         }
         this._title.setCellValue(this._titleInfo);
         this._titleII.setCellValue(this._titleInfoII);
         this.updateList();
         this.updatePageBtnState();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateList() : void
      {
         if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
         {
            this._list.visible = true;
            this.updatePlayDDTList();
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            this._list.visible = true;
            this.updateUnPlayDDTList();
         }
         else if(!this._currentTitleInfo.titleIsSelected)
         {
            if(Boolean(this._currentCMFInfo))
            {
               this._currentCMFInfo.isSelected = false;
            }
            this._list.visible = false;
            this.updateListPos();
         }
      }
      
      private function updatePlayDDTList() : void
      {
         this._CMFriendArray = [];
         this._CMFriendArray = PlayerManager.Instance.PlayCMFriendList;
         if(!this._CMFriendArray)
         {
            return;
         }
         this._playDDTListTotalPage = Math.ceil(this._CMFriendArray.length / LIST_MAX_NUM);
         this.updateItem();
      }
      
      private function updateUnPlayDDTList() : void
      {
         this._CMFriendArray = [];
         this._CMFriendArray = PlayerManager.Instance.UnPlayCMFriendList;
         if(!this._CMFriendArray)
         {
            return;
         }
         this._unplayDDTListTotalPage = Math.ceil(this._CMFriendArray.length / LIST_MAX_NUM);
         this.updateItem();
      }
      
      private function creatItem() : void
      {
         var item:CMFriendItem = null;
         for(var i:int = 0; i < LIST_MAX_NUM; i++)
         {
            item = new CMFriendItem();
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
            item.addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
            item.addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
            this._list.addChild(item);
            this._CMFriendItemArray.push(item);
         }
         this.updateListPos();
      }
      
      private function updateItem() : void
      {
         var top_1:int = 0;
         var top_4:int = 0;
         var num:int = 0;
         var i:int = 0;
         var Top_1:int = 0;
         var Top_4:int = 0;
         var Num:int = 0;
         var j:int = 0;
         if(this._currentTitleInfo.titleType == 0)
         {
            top_1 = this._playCurrentPage * LIST_MAX_NUM;
            top_4 = this._playCurrentPage * LIST_MAX_NUM + LIST_MAX_NUM - 1;
            num = 0;
            for(i = top_1; i <= top_4; i++)
            {
               if(Boolean(this._CMFriendArray[i] as CMFriendInfo) && Boolean(this._CMFriendItemArray[num]))
               {
                  this._CMFriendItemArray[num].visible = true;
                  this._CMFriendItemArray[num].info = this._CMFriendArray[i] as CMFriendInfo;
               }
               else if(Boolean(this._CMFriendItemArray[num]))
               {
                  this._CMFriendItemArray[num].visible = false;
               }
               num++;
            }
         }
         else if(this._currentTitleInfo.titleType == 1)
         {
            Top_1 = this._unplayCurrentPage * LIST_MAX_NUM;
            Top_4 = this._unplayCurrentPage * LIST_MAX_NUM + LIST_MAX_NUM - 1;
            Num = 0;
            for(j = Top_1; j <= Top_4; j++)
            {
               if(Boolean(this._CMFriendArray[j] as CMFriendInfo) && Boolean(this._CMFriendItemArray[num]))
               {
                  this._CMFriendItemArray[Num].visible = true;
                  this._CMFriendItemArray[Num].info = this._CMFriendArray[j] as CMFriendInfo;
               }
               else if(Boolean(this._CMFriendItemArray[num]))
               {
                  this._CMFriendItemArray[Num].visible = false;
               }
               Num++;
            }
         }
         this.updateListPos();
      }
      
      private function updateListPos() : void
      {
         if(this._currentTitleInfo.titleType == 0 && this._currentTitleInfo.titleIsSelected)
         {
            this._list.y = this._title.y + this._title.height - 7;
            this._titleII.y = this._list.y + this._list.height - 3;
         }
         else if(this._currentTitleInfo.titleType == 1 && this._currentTitleInfo.titleIsSelected)
         {
            this._titleII.y = this._title.y + this._title.height - 7;
            this._list.y = this._titleII.y + this._titleII.height - 7;
         }
         else
         {
            this._titleII.y = this._title.y + this._title.height - 7;
         }
      }
      
      private function cleanItem() : void
      {
         for(var i:int = 0; i < this._CMFriendItemArray.length; i++)
         {
            (this._CMFriendItemArray[i] as CMFriendItem).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._CMFriendItemArray[i] as CMFriendItem).removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
            (this._CMFriendItemArray[i] as CMFriendItem).removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
            (this._CMFriendItemArray[i] as CMFriendItem).dispose();
         }
         this._list.disposeAllChildren();
         this._CMFriendItemArray = [];
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentCMFInfo)
         {
            this._currentCMFInfo = (event.currentTarget as CMFriendItem).info;
            this._currentCMFInfo.isSelected = true;
         }
         else
         {
            if(this._currentCMFInfo == (event.currentTarget as CMFriendItem).info)
            {
               return;
            }
            this._currentCMFInfo.isSelected = false;
            this._currentCMFInfo = (event.currentTarget as CMFriendItem).info;
            this._currentCMFInfo.isSelected = true;
         }
         this.updateItem();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function __itemOut(event:MouseEvent) : void
      {
         this.resetItem();
         (event.currentTarget as CMFriendItem).itemOut();
      }
      
      private function __itemOver(event:MouseEvent) : void
      {
         this.resetItem();
         (event.currentTarget as CMFriendItem).itemOver();
      }
      
      private function resetItem() : void
      {
         for(var i:int = 0; i < this._CMFriendItemArray.length; i++)
         {
            (this._CMFriendItemArray[i] as CMFriendItem).itemOut();
         }
      }
      
      public function get currentCMFInfo() : CMFriendInfo
      {
         return this._currentCMFInfo;
      }
      
      public function get currentTitleInfo() : FriendListPlayer
      {
         return this._currentTitleInfo;
      }
      
      protected function __switchBtn1Click(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoSnsSend = this._switchBtn1.selected;
         if(!this._switchBtn1.selected)
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData1");
         }
         else
         {
            this._switchBtn1.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn1.tipData2");
         }
      }
      
      protected function __switchBtn2Click(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.allowSnsSend = this._switchBtn2.selected;
         if(!this._switchBtn2.selected)
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData1");
         }
         else
         {
            this._switchBtn2.tipData = LanguageMgr.GetTranslation("im.CMFriendList.switchBtn2.tipData2");
         }
      }
      
      public function dispose() : void
      {
         this.cleanItem();
         if(Boolean(this._list) && Boolean(this._list.parent))
         {
            this._list.parent.removeChild(this._list);
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._title) && Boolean(this._title.parent))
         {
            this._title.removeEventListener(MouseEvent.CLICK,this.__titleClick);
            this._title.parent.removeChild(this._title);
            this._title.dispose();
            this._title = null;
         }
         if(Boolean(this._titleII) && Boolean(this._titleII.parent))
         {
            this._titleII.removeEventListener(MouseEvent.CLICK,this.__titleClick);
            this._titleII.parent.removeChild(this._titleII);
            this._titleII.dispose();
            this._titleII = null;
         }
         if(Boolean(this._upPageBtn) && Boolean(this._upPageBtn.parent))
         {
            this._upPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
            this._upPageBtn.parent.removeChild(this._upPageBtn);
            this._upPageBtn.dispose();
            this._upPageBtn = null;
         }
         if(Boolean(this._downPageBtn) && Boolean(this._downPageBtn.parent))
         {
            this._downPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
            this._downPageBtn.parent.removeChild(this._downPageBtn);
            this._downPageBtn.dispose();
            this._downPageBtn = null;
         }
         if(Boolean(this._InviteBlogBtn))
         {
            this._InviteBlogBtn.removeEventListener(MouseEvent.CLICK,this.__inviteBolg);
            ObjectUtils.disposeObject(this._InviteBlogBtn);
            this._InviteBlogBtn = null;
         }
         if(Boolean(this._switchBtn1) && Boolean(this._switchBtn1.parent))
         {
            this._switchBtn1.removeEventListener(MouseEvent.CLICK,this.__switchBtn1Click);
            this._switchBtn1.parent.removeChild(this._switchBtn1);
            this._switchBtn1.dispose();
            this._switchBtn1 = null;
         }
         if(Boolean(this._switchBtn2) && Boolean(this._switchBtn2.parent))
         {
            this._switchBtn2.removeEventListener(MouseEvent.CLICK,this.__switchBtn2Click);
            this._switchBtn2.parent.removeChild(this._switchBtn2);
            this._switchBtn2.dispose();
            this._switchBtn2 = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

