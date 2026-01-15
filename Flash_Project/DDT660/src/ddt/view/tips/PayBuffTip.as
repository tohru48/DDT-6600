package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.BuffInfo;
   import flash.events.Event;
   
   public class PayBuffTip extends BuffTip
   {
      
      private var _buffContainer:VBox;
      
      private var _describe:String;
      
      public function PayBuffTip()
      {
         super();
         this._buffContainer = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipContainer");
         addChild(this._buffContainer);
         _activeSp.visible = false;
         addEventListener(Event.REMOVED_FROM_STAGE,this.__leaveStage);
      }
      
      private function __leaveStage(event:Event) : void
      {
         this._buffContainer.disposeAllChildren();
      }
      
      override protected function drawNameField() : void
      {
         name_txt = ComponentFactory.Instance.creat("core.PayBuffTipNameTxt");
         addChild(name_txt);
      }
      
      override protected function setShow(isActive:Boolean, isFree:Boolean, day:int, hour:int, min:int, describe:String) : void
      {
         var buff:* = undefined;
         _active = isActive;
         this._describe = describe;
         this._buffContainer.disposeAllChildren();
         if(_active)
         {
            for each(buff in _tempData.linkBuffs)
            {
               if(buff is BuffInfo)
               {
                  if(buff.Type != 70 && Boolean(buff.valided))
                  {
                     this._buffContainer.addChild(new PayBuffListItem(buff));
                  }
               }
               else
               {
                  this._buffContainer.addChild(new PayBuffListItem(buff));
               }
            }
         }
         this.updateTxt();
         this.updateWH();
      }
      
      private function updateTxt() : void
      {
         if(_active)
         {
            name_txt.text = _tempData.name;
            setChildIndex(name_txt,numChildren - 1);
            describe_txt.visible = false;
            name_txt.visible = true;
         }
         else
         {
            describe_txt.text = this._describe;
            describe_txt.visible = true;
            name_txt.visible = false;
         }
      }
      
      override protected function updateWH() : void
      {
         if(_active)
         {
            _bg.width = this._buffContainer.x + this._buffContainer.width + this._buffContainer.x;
            _bg.height = this._buffContainer.y + this._buffContainer.height + 16;
         }
         else
         {
            _bg.width = int(describe_txt.x + describe_txt.width);
            _bg.height = int(describe_txt.y + describe_txt.height + 10);
         }
         _width = _bg.width;
         _height = _bg.height;
      }
   }
}

