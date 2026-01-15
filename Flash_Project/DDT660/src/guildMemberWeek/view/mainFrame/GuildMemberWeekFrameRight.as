package guildMemberWeek.view.mainFrame
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import guildMemberWeek.items.AddRankingRecordItem;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class GuildMemberWeekFrameRight extends Sprite implements Disposeable
   {
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _itemList:Vector.<AddRankingRecordItem>;
      
      public function GuildMemberWeekFrameRight()
      {
         super();
         this.initView();
      }
      
      public function set itemList(value:Vector.<AddRankingRecordItem>) : void
      {
         this._itemList = value;
      }
      
      public function get itemList() : Vector.<AddRankingRecordItem>
      {
         return this._itemList;
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.RankingRecordListBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrameRight.scrollpanel");
         this.itemList = new Vector.<AddRankingRecordItem>();
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addChild(this._panel);
      }
      
      public function ClearRecord() : void
      {
         this.disposeItems();
         this.itemList = new Vector.<AddRankingRecordItem>();
      }
      
      public function UpRecord() : void
      {
         var item:AddRankingRecordItem = null;
         var L:int = int(GuildMemberWeekManager.instance.model.AddRanking.length);
         for(var i:int = int(this.itemList.length); i < L; )
         {
            item = ComponentFactory.Instance.creatCustomObject("guildmemberweek.MainFrame.Right.AddRankingRecordItem");
            item.initText(GuildMemberWeekManager.instance.model.AddRanking[i]);
            this.itemList.push(item);
            this._list.addChild(this.itemList[i]);
            i++;
         }
         this._panel.invalidateViewport();
      }
      
      private function disposeItems() : void
      {
         var i:int = 0;
         if(Boolean(this.itemList))
         {
            for(i = 0; i < this.itemList.length; i++)
            {
               ObjectUtils.disposeObject(this.itemList[i]);
               this.itemList[i] = null;
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
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

