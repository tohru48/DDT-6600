package email.view
{
   import auctionHouse.view.AuctionBagEquipListView;
   import auctionHouse.view.AuctionBagListView;
   import auctionHouse.view.AuctionBagView;
   import auctionHouse.view.AuctionBeadListView;
   import com.pickgliss.ui.controls.BaseButton;
   
   public class EmailBagView extends AuctionBagView
   {
      
      private var _beadBtn:BaseButton;
      
      public function EmailBagView()
      {
         super();
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new AuctionBagEquipListView(0);
         _proplist = new AuctionBagListView(1);
         _equiplist.x = _proplist.x = 14;
         _equiplist.y = _proplist.y = 54;
         _beadList = new AuctionBeadListView(21,32,80);
         _beadList2 = new AuctionBeadListView(21,81,129);
         _beadList3 = new AuctionBeadListView(21,130,178);
         _equiplist.x = _proplist.x = _beadList.x = _beadList2.x = _beadList3.x = 14;
         _equiplist.y = _proplist.y = _beadList.y = _beadList2.y = _beadList3.y = 54;
         _equiplist.width = _proplist.width = _beadList.width = _beadList2.width = _beadList3.width = 330;
         _equiplist.height = _proplist.height = _beadList.height = _beadList2.height = _beadList3.height = 320;
         _proplist.visible = false;
         _lists = [_equiplist,_proplist,_beadList,_beadList2,_beadList3];
         _currentList = _equiplist;
         addChild(_equiplist);
         addChild(_proplist);
         addChild(_beadList);
         addChild(_beadList2);
         addChild(_beadList3);
      }
      
      override protected function adjustEvent() : void
      {
      }
   }
}

