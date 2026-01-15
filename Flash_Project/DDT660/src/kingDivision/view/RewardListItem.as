package kingDivision.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RewardListItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _topThreeRink:ScaleFrameImage;
      
      private var _index:int;
      
      private var _goodsList:RewardGoodsList;
      
      private var _leftBtn:BaseButton;
      
      private var _rightBtn:BaseButton;
      
      private var _panel:ScrollPanel;
      
      private var _select:int;
      
      private var _zoneIndex:int;
      
      public function RewardListItem(index:int, zoneIndex:int)
      {
         super();
         this._index = index;
         this._zoneIndex = zoneIndex;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.rewardView.midsole");
         this._topThreeRink = ComponentFactory.Instance.creat("kingDivision.RewardListItem.topThreeRink");
         this._topThreeRink.visible = false;
         this._goodsList = ComponentFactory.Instance.creatComponentByStylename("kingDivision.RewardGoodsList");
         this._goodsList.setGoodsListItem(this._zoneIndex);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("assets.RewardListItem.consorPanel");
         this._panel.mouseEnabled = false;
         this._panel.setView(this._goodsList);
         this._leftBtn = ComponentFactory.Instance.creat("kingDivision.RewardListItem.leftBtn");
         this._leftBtn.enable = false;
         this._rightBtn = ComponentFactory.Instance.creat("kingDivision.RewardListItem.rightBtn");
         if(this._panel.hScrollbar.scrollValue > 0)
         {
            this._leftBtn.enable = true;
         }
         addChild(this._bg);
         addChild(this._topThreeRink);
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         addChild(this._panel);
         this.setRink();
      }
      
      private function addEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__onClickLeftBtn);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__onClickRightBtn);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_UP,this.__onMouseUpBtn);
         this._leftBtn.addEventListener(MouseEvent.MOUSE_UP,this.__onMouseUpBtn);
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onClickLeftBtn);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onClickRightBtn);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_UP,this.__onMouseUpBtn);
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_UP,this.__onMouseUpBtn);
         this._panel.hScrollbar.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function setRink() : void
      {
         this._topThreeRink.visible = true;
         this._topThreeRink.setFrame(this._index + 1);
      }
      
      private function __onClickLeftBtn(evt:MouseEvent) : void
      {
         this._select = 0;
         this._panel.hScrollbar.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __onClickRightBtn(evt:MouseEvent) : void
      {
         this._select = 1;
         this._panel.hScrollbar.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(evt:Event) : void
      {
         if(this._panel != null && this._select == 0)
         {
            if(this._panel != null && this._leftBtn.enable && this._panel.hScrollbar.scrollValue <= 0)
            {
               this._leftBtn.enable = false;
            }
            this._panel.hScrollbar.scrollValue -= 10;
         }
         else if(this._panel != null && this._select == 1)
         {
            if(this._panel != null && !this._leftBtn.enable && this._panel.hScrollbar.scrollValue > 0)
            {
               this._leftBtn.enable = true;
            }
            this._panel.hScrollbar.scrollValue += 10;
         }
         if(this._goodsList.width - 268 <= Math.abs(this._goodsList.x))
         {
            this._rightBtn.enable = false;
         }
         else
         {
            this._rightBtn.enable = true;
         }
      }
      
      private function __onMouseUpBtn(evt:MouseEvent) : void
      {
         this._panel.hScrollbar.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._topThreeRink = null;
         this._panel = null;
         this._leftBtn = null;
         this._rightBtn = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

