package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaDutyInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   
   public class JobManageItem extends Sprite implements Disposeable
   {
      
      private var _name:FilterFrameText;
      
      private var _btn:TextButton;
      
      private var _light:Bitmap;
      
      private var _nameBG:Scale9CornerImage;
      
      private var _dutyInfo:ConsortiaDutyInfo;
      
      private var _editable:Boolean;
      
      private var _selected:Boolean;
      
      public function JobManageItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._name = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.name");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.btn");
         this._light = ComponentFactory.Instance.creatBitmap("asset.consortion.jobManage.light");
         this._nameBG = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManageItem.nameBG");
         addChild(this._nameBG);
         addChild(this._name);
         addChild(this._btn);
         addChild(this._light);
         this._light.visible = false;
         this._nameBG.visible = false;
         this._btn.text = LanguageMgr.GetTranslation("change");
         this._btn.buttonMode = true;
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.__btnClickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      public function set dutyInfo(info:ConsortiaDutyInfo) : void
      {
         this._dutyInfo = info;
         this._name.text = this._dutyInfo.DutyName;
         this.selected = false;
      }
      
      private function __btnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.editable = !this.editable;
         if(!this.editable && this.upText)
         {
            ConsortionModelControl.Instance.model.changeDutyListName(this._dutyInfo.DutyID,this._name.text);
            SocketManager.Instance.out.sendConsortiaUpdateDuty(this._dutyInfo.DutyID,this._name.text,this._dutyInfo.Level);
         }
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
         var frameIndex:int = this._editable ? 2 : 1;
         this._btn.setFrame(frameIndex);
         if(frameIndex == 1)
         {
            this._btn.text = LanguageMgr.GetTranslation("change");
         }
         else
         {
            this._btn.text = LanguageMgr.GetTranslation("ok");
         }
         if(this._editable)
         {
            this._nameBG.visible = true;
            this._name.type = TextFieldType.INPUT;
            this._name.mouseEnabled = true;
            this._name.setFocus();
            this._name.setSelection(this._name.text.length,this._name.text.length);
         }
         else
         {
            this._nameBG.visible = false;
            this._name.type = TextFieldType.DYNAMIC;
            this._name.mouseEnabled = false;
         }
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function get upText() : Boolean
      {
         if(this._name.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaJobItem.null"));
            this.setDefultName();
            return false;
         }
         if(this._name.text == this._dutyInfo.DutyName)
         {
            return false;
         }
         var list:Vector.<ConsortiaDutyInfo> = ConsortionModelControl.Instance.model.dutyList;
         var len:int = int(list.length);
         for(var i:int = 0; i < len; i++)
         {
            if(list[i].DutyName == this._name.text)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaJobItem.diffrent"));
               this.setDefultName();
               return false;
            }
         }
         if(FilterWordManager.isGotForbiddenWords(this._name.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaJobItem.duty"));
            this.setDefultName();
            return false;
         }
         return true;
      }
      
      private function setDefultName() : void
      {
         var list:Vector.<ConsortiaDutyInfo> = ConsortionModelControl.Instance.model.dutyList;
         var len:int = int(list.length);
         var _index:int = int(this.name);
         for(var i:int = 0; i < len; i++)
         {
            if(_index == i)
            {
               this._name.text = list[i].DutyName;
            }
         }
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this._light.visible = this._selected;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      private function __mouseOverHandler(event:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __mouseOutHandler(event:MouseEvent) : void
      {
         if(!this.selected)
         {
            this._light.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._name = null;
         this._btn = null;
         this._light = null;
         this._nameBG = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

