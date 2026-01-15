package horseRace.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HorseRacePlayerInfoView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _itemList:Array = [];
      
      public var selectItemId:int = 0;
      
      public function HorseRacePlayerInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("horseRace.raceView.playerInfoBg");
         addChild(this._bg);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.raceView.PlayerList");
         addChild(this._vbox);
      }
      
      public function addPlayerItem(playerItem:HorseRacePlayerItemView) : void
      {
         this._vbox.addChild(playerItem);
         playerItem.addEventListener(MouseEvent.CLICK,this._itemClick);
         this._itemList.push(playerItem);
      }
      
      public function flushBuffList() : void
      {
         var item2:HorseRacePlayerItemView = null;
         var buffList:Array = null;
         for(var i:int = 0; i < this._itemList.length; i++)
         {
            item2 = this._itemList[i] as HorseRacePlayerItemView;
            buffList = item2.getPlayerInfo().buffList;
            item2.flashBuffList(buffList);
         }
      }
      
      private function _itemClick(e:MouseEvent) : void
      {
         var item2:HorseRacePlayerItemView = null;
         var item:HorseRacePlayerItemView = e.currentTarget as HorseRacePlayerItemView;
         for(var i:int = 0; i < this._itemList.length; i++)
         {
            item2 = this._itemList[i] as HorseRacePlayerItemView;
            if(item2.getPlayerInfo().playerVO.playerInfo.ID == item.getPlayerInfo().playerVO.playerInfo.ID)
            {
               item2.setBgVisible(true);
               this.selectItemId = item.getPlayerInfo().playerVO.playerInfo.ID;
            }
            else
            {
               item2.setBgVisible(false);
            }
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

