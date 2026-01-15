package cardSystem.view.cardEquip
{
   import bagAndInfo.cell.DragEffect;
   import cardSystem.data.CardInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class CardEquipDragArea extends Sprite implements IAcceptDrag
   {
      
      private var _view:CardEquipView;
      
      public function CardEquipDragArea(view:CardEquipView)
      {
         super();
         this._view = view;
         this.init();
      }
      
      private function init() : void
      {
         graphics.beginFill(65280,0);
         graphics.drawRect(-9,6,397,257);
         graphics.endFill();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var dic:DictionaryData = null;
         var i:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var cInfo:CardInfo = effect.data as CardInfo;
         if(Boolean(cInfo))
         {
            if(cInfo.templateInfo.Property8 == "1")
            {
               SocketManager.Instance.out.sendMoveCards(cInfo.Place,0);
               effect.action = DragEffect.NONE;
            }
            else
            {
               dic = PlayerManager.Instance.Self.cardEquipDic;
               for(i = 1; i < 5; i++)
               {
                  if((dic[i] == null || dic[i].Count < 0) && this._view._equipCells[i].open)
                  {
                     SocketManager.Instance.out.sendMoveCards(cInfo.Place,i);
                     effect.action = DragEffect.NONE;
                     break;
                  }
                  if(i == 4)
                  {
                     SocketManager.Instance.out.sendMoveCards(cInfo.Place,1);
                     effect.action = DragEffect.NONE;
                  }
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

