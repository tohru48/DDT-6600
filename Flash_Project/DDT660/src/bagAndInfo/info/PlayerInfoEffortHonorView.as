package bagAndInfo.info
{
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.EffortEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hall.event.NewHallEvent;
   import newTitle.NewTitleManager;
   import newTitle.event.NewTitleEvent;
   
   public class PlayerInfoEffortHonorView extends Sprite implements Disposeable
   {
      
      private var _nameChoose:ComboBox;
      
      private var _honorArray:Array;
      
      public function PlayerInfoEffortHonorView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._nameChoose = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNameChoose");
         addChild(this._nameChoose);
         this._nameChoose.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         NewTitleManager.instance.addEventListener(NewTitleEvent.SELECT_TITLE,this.__onSelectTitle);
         this.setlist(EffortManager.Instance.getHonorArray());
         this.update();
      }
      
      private function __onSelectTitle(event:NewTitleEvent) : void
      {
         var honor:String = event.data[0];
         if(Boolean(honor))
         {
            SocketManager.Instance.out.sendReworkRank(honor);
         }
         else
         {
            SocketManager.Instance.out.sendReworkRank("");
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
         }
      }
      
      private function __upadte(event:EffortEvent) : void
      {
         this.setlist(EffortManager.Instance.getHonorArray());
         this.update();
      }
      
      private function __propertyChange(event:PlayerPropertyEvent) : void
      {
         if(event.changedProperties["honor"] == true)
         {
            if(PlayerManager.Instance.Self.honor != "")
            {
               this._nameChoose.textField.text = PlayerManager.Instance.Self.honor;
               SocketManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.UPDATETITLE));
               NewTitleManager.instance.dispatchEvent(new NewTitleEvent(NewTitleEvent.SET_SELECT_TITLE));
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newTitleView.useTitleSuccessTxt",this._nameChoose.textField.text));
            }
            else
            {
               this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
            }
         }
      }
      
      private function __buttonClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         NewTitleManager.instance.show();
      }
      
      private function update() : void
      {
         if(PlayerManager.Instance.Self.honor != "")
         {
            this._nameChoose.textField.text = PlayerManager.Instance.Self.honor;
         }
         else
         {
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
         }
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         var honor:String = this._honorArray[event.index];
         if(Boolean(honor))
         {
            SocketManager.Instance.out.sendReworkRank(honor);
            this.checkCllProp(honor);
         }
         else
         {
            SocketManager.Instance.out.sendReworkRank("");
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
            this._nameChoose.button.tipData = new CallPropTxtTipInfo();
         }
      }
      
      private function checkCllProp(value:String) : void
      {
         if(Boolean(PlayerManager.Instance.callPropData) && Boolean(PlayerManager.Instance.callPropData[value]))
         {
            this._nameChoose.button.tipData = PlayerManager.Instance.callPropData[value] as CallPropTxtTipInfo;
         }
         else
         {
            this._nameChoose.button.tipData = new CallPropTxtTipInfo();
         }
      }
      
      public function setlist(honorArray:Array) : void
      {
         this._honorArray = [];
         this._honorArray = honorArray;
         if(!this._honorArray)
         {
            return;
         }
      }
      
      public function dispose() : void
      {
         this._nameChoose.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(Boolean(this._nameChoose))
         {
            ObjectUtils.disposeObject(this._nameChoose);
         }
         this._nameChoose = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

