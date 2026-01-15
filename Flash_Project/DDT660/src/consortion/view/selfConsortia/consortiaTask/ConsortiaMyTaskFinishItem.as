package consortion.view.selfConsortia.consortiaTask
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortiaMyTaskFinishItem extends Sprite implements Disposeable
   {
      
      public static const DONATE_TYPE:int = 5;
      
      private var _noFinishValue:int;
      
      private var _bg:ScaleBitmapImage;
      
      private var _donateBtn:BaseButton;
      
      private var _finishTxt:FilterFrameText;
      
      private var _myFinishTxt:FilterFrameText;
      
      public function ConsortiaMyTaskFinishItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.task.bg1");
         this._donateBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.task.donateBtn");
         this._finishTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.finishTxt");
         this._myFinishTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.finishNumberTxt");
         addChild(this._bg);
         addChild(this._donateBtn);
         addChild(this._finishTxt);
         addChild(this._myFinishTxt);
         this._donateBtn.visible = false;
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
         this._donateBtn.addEventListener(MouseEvent.CLICK,this.__donateClick);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
         this._donateBtn.removeEventListener(MouseEvent.CLICK,this.__donateClick);
      }
      
      private function __over(e:MouseEvent) : void
      {
         this._finishTxt.setFrame(2);
         this._myFinishTxt.setFrame(2);
      }
      
      private function __out(e:MouseEvent) : void
      {
         this._finishTxt.setFrame(1);
         this._myFinishTxt.setFrame(1);
      }
      
      private function __donateClick(e:MouseEvent) : void
      {
         var frame:DonateFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.BandMoney > 0)
         {
            frame = ComponentFactory.Instance.creatComponentByStylename("DonateFrame");
            frame.targetValue = this._noFinishValue;
            frame.show();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.noMedal"));
         }
      }
      
      public function update(taskType:int, itemName:String, number:int, targetValue:int) : void
      {
         this._noFinishValue = targetValue - number;
         this._finishTxt.text = itemName;
         this._myFinishTxt.text = number.toString();
         if(taskType == DONATE_TYPE)
         {
            if(number < targetValue)
            {
               this._donateBtn.visible = true;
               this._finishTxt.x = 45;
            }
            else
            {
               this._donateBtn.visible = false;
               this._finishTxt.x = 3;
            }
         }
         else
         {
            this._donateBtn.visible = false;
            this._finishTxt.x = 3;
         }
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._donateBtn))
         {
            ObjectUtils.disposeObject(this._donateBtn);
         }
         this._donateBtn = null;
         if(Boolean(this._finishTxt))
         {
            ObjectUtils.disposeObject(this._finishTxt);
         }
         this._finishTxt = null;
         if(Boolean(this._myFinishTxt))
         {
            ObjectUtils.disposeObject(this._myFinishTxt);
         }
         this._myFinishTxt = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

