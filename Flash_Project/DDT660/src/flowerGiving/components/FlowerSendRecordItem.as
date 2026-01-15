package flowerGiving.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import flowerGiving.data.FlowerSendRecordInfo;
   import flowerGiving.events.FlowerSendRecordEvent;
   
   public class FlowerSendRecordItem extends Sprite implements Disposeable
   {
      
      private var _timeTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _huikuiBtn:SimpleBitmapButton;
      
      private var _sender:String;
      
      private var _num:int;
      
      private var _receiver:String;
      
      public function FlowerSendRecordItem(index:int)
      {
         super();
         this.initView();
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,490,index % 2 == 0 ? 34 : 32);
         this.graphics.endFill();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.Txt");
         addChild(this._timeTxt);
         PositionUtils.setPos(this._timeTxt,"flowerGiving.flowerSendRecordFrame.timePos");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.Txt");
         addChild(this._contentTxt);
         PositionUtils.setPos(this._contentTxt,"flowerGiving.flowerSendFrame.contentPos");
         this._huikuiBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.huiKuiBtn");
         addChild(this._huikuiBtn);
      }
      
      public function setData(info:FlowerSendRecordInfo) : void
      {
         this._num = info.num;
         if(info.flag)
         {
            this._sender = "bir";
            this._receiver = info.nickName;
            this._huikuiBtn.visible = false;
         }
         else
         {
            this._sender = info.nickName;
            this._receiver = "bir";
            this._huikuiBtn.visible = true;
         }
         this._contentTxt.htmlText = LanguageMgr.GetTranslation("flowerGiving.flowerSendRecordFrame.contentTxt",this._sender,this._num,this._receiver);
         this._timeTxt.text = info.date;
      }
      
      private function addEvent() : void
      {
         this._huikuiBtn.addEventListener(MouseEvent.CLICK,this.__huikuiClick);
      }
      
      protected function __huikuiClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FlowerGivingManager.instance.dispatchEvent(new FlowerSendRecordEvent(FlowerSendRecordEvent.HUIKUI_FLOWER,this._sender));
      }
      
      private function removeEvent() : void
      {
         this._huikuiBtn.removeEventListener(MouseEvent.CLICK,this.__huikuiClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.graphics.clear();
         ObjectUtils.disposeAllChildren(this);
         this._timeTxt = null;
         this._contentTxt = null;
         this._huikuiBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

