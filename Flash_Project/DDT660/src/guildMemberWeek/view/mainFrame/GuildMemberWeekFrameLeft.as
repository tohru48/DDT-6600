package guildMemberWeek.view.mainFrame
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import guildMemberWeek.items.ShowGuildMemberDataItem;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class GuildMemberWeekFrameLeft extends Sprite implements Disposeable
   {
      
      private var _itemList:Vector.<ShowGuildMemberDataItem>;
      
      private var _list:VBox;
      
      public function GuildMemberWeekFrameLeft()
      {
         super();
         this.initView();
      }
      
      public function set itemList(value:Vector.<ShowGuildMemberDataItem>) : void
      {
         this._itemList = value;
      }
      
      public function get itemList() : Vector.<ShowGuildMemberDataItem>
      {
         return this._itemList;
      }
      
      private function initView() : void
      {
         var item:ShowGuildMemberDataItem = null;
         this._list = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.RankingTopTenListBox");
         this.itemList = new Vector.<ShowGuildMemberDataItem>();
         for(var i:int = 0; i < 10; )
         {
            item = ComponentFactory.Instance.creatCustomObject("guildmemberweek.MainFrame.Left.ShowGuildMemberDataItem");
            item.initView(i + 1);
            item.initAddPointBook(0);
            item.initItemCell(GuildMemberWeekManager.instance.model.TopTenGiftData[i]);
            this.itemList.push(item);
            this._list.addChild(this.itemList[i]);
            i++;
         }
         addChild(this._list);
         this.UpTop10data("Gift");
      }
      
      public function UpTop10data(UpType:String) : void
      {
         for(var i:int = 0; i < 10; )
         {
            if(UpType == "Member")
            {
               if(GuildMemberWeekManager.instance.model.TopTenMemberData[i] != null)
               {
                  this.itemList[i].initMember(GuildMemberWeekManager.instance.model.TopTenMemberData[i][1],GuildMemberWeekManager.instance.model.TopTenMemberData[i][3]);
               }
            }
            else if(UpType == "PointBook")
            {
               this.itemList[i].initAddPointBook(GuildMemberWeekManager.instance.model.TopTenAddPointBook[i]);
            }
            else if(UpType == "Gift")
            {
               this.itemList[i].initItemCell(GuildMemberWeekManager.instance.model.TopTenGiftData[i]);
            }
            i++;
         }
      }
      
      private function disposeItems() : void
      {
         var i:int = 0;
         var L:int = 0;
         if(Boolean(this.itemList))
         {
            i = 0;
            for(L = int(this.itemList.length); i < L; )
            {
               ObjectUtils.disposeObject(this.itemList[i]);
               this.itemList[i] = null;
               i++;
            }
            this.itemList = null;
         }
      }
      
      public function dispose() : void
      {
         this.disposeItems();
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

