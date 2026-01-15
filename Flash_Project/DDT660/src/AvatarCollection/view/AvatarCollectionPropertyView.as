package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionPropertyView extends Sprite implements Disposeable
   {
      
      private var _propertyCellList:Vector.<AvatarCollectionPropertyCell>;
      
      private var _allPropertyView:AvatarCollectionAllPropertyView;
      
      private var _tip:AvatarCollectionPropertyTip;
      
      private var _tipSprite:Sprite;
      
      private var _completeStatus:int = -1;
      
      public function AvatarCollectionPropertyView()
      {
         super();
         this.x = 22;
         this.y = 252;
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmp:AvatarCollectionPropertyCell = null;
         this._propertyCellList = new Vector.<AvatarCollectionPropertyCell>();
         this._allPropertyView = new AvatarCollectionAllPropertyView();
         this._allPropertyView.x = 274;
         this._allPropertyView.y = 0;
         addChild(this._allPropertyView);
         for(i = 0; i < 7; i++)
         {
            tmp = new AvatarCollectionPropertyCell(i);
            tmp.x = int(i / 4) * 110;
            tmp.y = i % 4 * 25;
            addChild(tmp);
            this._propertyCellList.push(tmp);
         }
         this._tip = new AvatarCollectionPropertyTip();
         this._tip.visible = false;
         PositionUtils.setPos(this._tip,"avatarColl.propertyView.tipPos");
         addChild(this._tip);
         this._tipSprite = new Sprite();
         this._tipSprite.graphics.beginFill(16711680,0);
         this._tipSprite.graphics.drawRect(-15,-20,242,122);
         this._tipSprite.graphics.endFill();
         addChild(this._tipSprite);
      }
      
      private function initEvent() : void
      {
         this._tipSprite.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         this._tipSprite.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         if(this._completeStatus == 0 || this._completeStatus == 1)
         {
            this._tip.visible = true;
         }
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      public function refreshView(data:AvatarCollectionUnitVo) : void
      {
         var tmp:AvatarCollectionPropertyCell = null;
         var totalCount:int = 0;
         var activityCount:int = 0;
         if(Boolean(data))
         {
            totalCount = int(data.totalItemList.length);
            activityCount = data.totalActivityItemCount;
            if(activityCount < totalCount / 2)
            {
               this._completeStatus = 0;
               this._tip.refreshView(data,1);
            }
            else if(activityCount == totalCount)
            {
               this._completeStatus = 2;
            }
            else
            {
               this._completeStatus = 1;
               this._tip.refreshView(data,2);
            }
         }
         else
         {
            this._completeStatus = -1;
         }
         for each(tmp in this._propertyCellList)
         {
            tmp.refreshView(data,this._completeStatus);
         }
         this._allPropertyView.refreshView();
      }
      
      private function removeEvent() : void
      {
         this._tipSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this._tipSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._propertyCellList = null;
         this._tip = null;
         this._tipSprite = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

