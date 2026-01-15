package ddt.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddtBuried.items.BuriedCardItem;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TransactionsFrame extends BaseAlerFrame
   {
      
      private var _selectedCheckButton:SelectedCheckButton;
      
      public var buyFunction:Function;
      
      public var clickFunction:Function;
      
      private var _txt:FilterFrameText;
      
      private var _target:Sprite;
      
      public var autoClose:Boolean = true;
      
      public function TransactionsFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function set target($target:Sprite) : void
      {
         this._target = $target;
      }
      
      private function initView() : void
      {
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = alerInfo;
         this._selectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("core.TransactionsFrame.selectBtn");
         this._selectedCheckButton.text = LanguageMgr.GetTranslation("labyrinth.view.buyFrame.SelectedCheckButtonText");
         this._selectedCheckButton.x = 126;
         this._selectedCheckButton.y = 103;
         addToContent(this._selectedCheckButton);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("core.alert.txt");
         addToContent(this._txt);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHander);
         this._selectedCheckButton.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      private function mouseClickHander(e:MouseEvent) : void
      {
         if(this.clickFunction != null)
         {
            this.clickFunction(this._selectedCheckButton.selected);
         }
      }
      
      private function removeEvnets() : void
      {
         this._selectedCheckButton.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         removeEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function responseHander(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.buyFunction != null)
            {
               this.buyFunction(false);
            }
            if(this.autoClose)
            {
               this.dispose();
            }
         }
         else if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.CANCEL_CLICK)
         {
            if(Boolean(this._target))
            {
               if(this._target is BuriedCardItem)
               {
                  BuriedCardItem(this._target).isPress = false;
               }
            }
            this.dispose();
         }
      }
      
      public function get isBind() : Boolean
      {
         return false;
      }
      
      public function setTxt(str:String) : void
      {
         this._txt.text = str;
      }
      
      override public function dispose() : void
      {
         this.removeEvnets();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
      }
   }
}

