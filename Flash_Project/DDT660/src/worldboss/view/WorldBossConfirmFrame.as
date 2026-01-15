package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class WorldBossConfirmFrame extends WorldBossBuyBuffConfirmFrame
   {
      
      protected var _responseCellBack:Function;
      
      protected var _selectedCheckButtonCellBack:Function;
      
      public function WorldBossConfirmFrame()
      {
         super();
      }
      
      public function showFrame(title:String, content:String, responseCellBack:Function = null, selectedCheckButtonCellBack:Function = null) : void
      {
         var alertInfo:AlertInfo = this.info;
         alertInfo.title = title;
         _alertTips.text = content;
         this._responseCellBack = responseCellBack;
         this._selectedCheckButtonCellBack = selectedCheckButtonCellBack;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override protected function __framePesponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._responseCellBack != null)
               {
                  this._responseCellBack();
               }
               return;
         }
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override protected function __noAlertTip(e:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedCheckButtonCellBack != null)
         {
            this._selectedCheckButtonCellBack(_buyBtn.selected);
         }
      }
   }
}

