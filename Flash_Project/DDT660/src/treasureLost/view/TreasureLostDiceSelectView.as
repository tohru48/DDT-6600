package treasureLost.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import treasureLost.events.TreasureLostEvents;
   
   public class TreasureLostDiceSelectView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var buttonArr:Array;
      
      private var okBnt:SimpleBitmapButton;
      
      public var selectBntId:int = -1;
      
      public function TreasureLostDiceSelectView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var selectBnt:TreasureLostGoldSelectButton = null;
         this.buttonArr = [];
         this._bg = ComponentFactory.Instance.creat("treasureLost.goldDiceSelectBG");
         addChild(this._bg);
         this.okBnt = ComponentFactory.Instance.creatComponentByStylename("treasureLost.goldDiceSelectOk");
         addChild(this.okBnt);
         for(var i:int = 0; i < 6; i++)
         {
            selectBnt = ComponentFactory.Instance.creatComponentByStylename("treasureLost.goldDiceSelectBnt" + i);
            selectBnt.selectId = i;
            selectBnt.select = false;
            addChild(selectBnt);
            this.buttonArr.push(selectBnt);
         }
      }
      
      private function initEvents() : void
      {
         var selectBnt:TreasureLostGoldSelectButton = null;
         for(var i:int = 0; i < this.buttonArr.length; i++)
         {
            selectBnt = this.buttonArr[i] as TreasureLostGoldSelectButton;
            selectBnt.addEventListener(MouseEvent.CLICK,this._select);
         }
         this.okBnt.addEventListener(MouseEvent.CLICK,this.__okClick);
      }
      
      private function __okClick(e:MouseEvent) : void
      {
         if(this.selectBntId == -1)
         {
            return;
         }
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.SELECTGOLDDICEROLL,this.selectBntId));
      }
      
      private function _select(e:MouseEvent) : void
      {
         var selectBnt:TreasureLostGoldSelectButton = null;
         var bnt:TreasureLostGoldSelectButton = e.currentTarget as TreasureLostGoldSelectButton;
         for(var i:int = 0; i < this.buttonArr.length; i++)
         {
            selectBnt = this.buttonArr[i] as TreasureLostGoldSelectButton;
            if(bnt.selectId == selectBnt.selectId)
            {
               selectBnt.select = true;
               this.selectBntId = bnt.selectId + 1;
            }
            else
            {
               selectBnt.select = false;
            }
         }
      }
      
      public function reset() : void
      {
         var selectBnt:TreasureLostGoldSelectButton = null;
         for(var i:int = 0; i < this.buttonArr.length; i++)
         {
            selectBnt = this.buttonArr[i] as TreasureLostGoldSelectButton;
            selectBnt.select = false;
         }
         this.selectBntId = -1;
      }
      
      private function removeEvents() : void
      {
         var selectBnt:TreasureLostGoldSelectButton = null;
         for(var i:int = 0; i < this.buttonArr.length; i++)
         {
            selectBnt = this.buttonArr[i] as TreasureLostGoldSelectButton;
            selectBnt.removeEventListener(MouseEvent.CLICK,this._select);
         }
         this.okBnt.removeEventListener(MouseEvent.CLICK,this.__okClick);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

