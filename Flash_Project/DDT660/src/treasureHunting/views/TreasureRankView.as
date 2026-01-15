package treasureHunting.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.RouletteManager;
   import ddt.view.caddyII.CaddyEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import treasureHunting.items.LuckRankItem;
   
   public class TreasureRankView extends Sprite implements Disposeable
   {
      
      private var _rankBG:Bitmap;
      
      private var _itemBGDeep:Bitmap;
      
      private var _itemBGLighter:Bitmap;
      
      private var _ranklist:VBox;
      
      private var _itemList:Vector.<LuckRankItem>;
      
      private var _dataList:Vector.<Object> = new Vector.<Object>();
      
      public function TreasureRankView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var item:LuckRankItem = null;
         this._rankBG = ComponentFactory.Instance.creat("treasureHunting.rankBG");
         addChild(this._rankBG);
         this._ranklist = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.LuckBox");
         addChild(this._ranklist);
         this._itemList = new Vector.<LuckRankItem>();
         for(var i:int = 0; i < 10; i++)
         {
            item = new LuckRankItem(i);
            item.addEventListener(MouseEvent.CLICK,this.onItemClick);
            this._ranklist.addChild(item);
            this._itemList.push(item);
         }
      }
      
      protected function onItemClick(event:MouseEvent) : void
      {
         for(var i:int = 0; i <= this._itemList.length - 1; i++)
         {
            (this._itemList[i] as LuckRankItem).selected = false;
         }
         (event.currentTarget as LuckRankItem).selected = true;
      }
      
      private function initEvent() : void
      {
         RouletteManager.instance.addEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getLuckRank);
      }
      
      protected function __getLuckRank(event:CaddyEvent) : void
      {
         var obj:Object = null;
         this._dataList = event.dataList;
         var i:int = 0;
         while(i < 10 && i < this._dataList.length)
         {
            obj = this._dataList[i];
            this._itemList[i].update(i,obj["Nickname"],obj["Count"]);
            i++;
         }
      }
      
      private function removeEvent() : void
      {
         RouletteManager.instance.removeEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getLuckRank);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._rankBG))
         {
            ObjectUtils.disposeObject(this._rankBG);
         }
         this._rankBG = null;
         if(Boolean(this._ranklist))
         {
            ObjectUtils.disposeObject(this._ranklist);
         }
         this._ranklist = null;
         this._itemList = null;
         this._dataList = null;
      }
   }
}

