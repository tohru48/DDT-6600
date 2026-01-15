package ddtBuried
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.views.BuriedView;
   import ddtBuried.views.DiceView;
   
   public class BuriedFrame extends Frame
   {
      
      private static const MAP1:int = 1;
      
      private static const MAP2:int = 2;
      
      private static const MAP3:int = 3;
      
      private var _buriedView:BuriedView;
      
      private var _diceView:DiceView;
      
      private var _type:int;
      
      public function BuriedFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
      }
      
      public function addDiceView(type:int) : void
      {
         this._diceView = new DiceView();
         switch(type)
         {
            case MAP1:
               this._diceView.addMaps(BuriedManager.Instance.mapArrays.itemMaps1,11,7,2,94);
               break;
            case MAP2:
               this._diceView.addMaps(BuriedManager.Instance.mapArrays.itemMaps2,8,8,136,81);
               break;
            case MAP3:
               this._diceView.addMaps(BuriedManager.Instance.mapArrays.itemMaps3,9,8,136,74);
         }
         addToContent(this._diceView);
      }
      
      public function setStarList(num:int) : void
      {
         this._diceView.setStarList(num);
      }
      
      public function updataStarLevel(num:int) : void
      {
         this._diceView.updataStarLevel(num);
      }
      
      public function setCrFrame(str:String) : void
      {
         this._diceView.setCrFrame(str);
      }
      
      public function setTxt(str:String) : void
      {
         this._diceView.setTxt(str);
      }
      
      public function play() : void
      {
         this._diceView.play();
      }
      
      public function upDataBtn() : void
      {
         this._diceView.upDataBtn();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         BuriedManager.evnetDispatch.addEventListener(BuriedEvent.OPEN_BURIEDVIEW,this.openBuriedHander);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         BuriedManager.evnetDispatch.removeEventListener(BuriedEvent.OPEN_BURIEDVIEW,this.openBuriedHander);
      }
      
      private function openBuriedHander(e:BuriedEvent) : void
      {
         if(Boolean(this._buriedView))
         {
            ObjectUtils.disposeObject(this._buriedView);
            this._buriedView = null;
         }
         this._buriedView = new BuriedView();
         addToContent(this._buriedView);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._diceView))
         {
            this._diceView.dispose();
         }
         if(Boolean(this._buriedView))
         {
            this._buriedView.dispose();
         }
         ObjectUtils.disposeObject(this._buriedView);
         ObjectUtils.disposeObject(this._diceView);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
         this._diceView = null;
         this._buriedView = null;
         SocketManager.Instance.out.outCard();
      }
   }
}

