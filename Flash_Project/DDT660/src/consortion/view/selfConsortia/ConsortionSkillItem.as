package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.data.ConsortionSkillInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortionSkillItem extends Sprite implements Disposeable
   {
      
      private var _bg1:ScaleBitmapImage;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _bg3:ScaleBitmapImage;
      
      private var _cellBG1:DisplayObject;
      
      private var _cellBG2:DisplayObject;
      
      private var _sign:FilterFrameText;
      
      private var _level:int;
      
      private var _open:Boolean;
      
      private var _isMetal:Boolean;
      
      private var _cells:Vector.<ConsortionSkillCell>;
      
      private var _btns:Vector.<ConsortionSkillItenBtn>;
      
      private var _currentInfo:ConsortionSkillInfo;
      
      public function ConsortionSkillItem(level:int, open:Boolean, isMetal:Boolean = false)
      {
         super();
         this._level = level;
         this._open = open;
         this._isMetal = isMetal;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("skillFrame.ItemBG1");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("skillFrame.ItemBG2");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("skillFrame.ItemBG3");
         this._cellBG1 = ComponentFactory.Instance.creatCustomObject("skillFrame.ItemCellBG1");
         this._cellBG2 = ComponentFactory.Instance.creatCustomObject("skillFrame.ItemCellBG2");
         this._sign = ComponentFactory.Instance.creatComponentByStylename("consortion.skillFrame.gradeText");
         this._sign.text = "LV" + this._level;
         addChild(this._bg1);
         addChild(this._bg2);
         addChild(this._bg3);
         addChild(this._cellBG1);
         addChild(this._cellBG2);
         addChild(this._sign);
         if(!this._open)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
         this._cells = new Vector.<ConsortionSkillCell>(2);
         this._btns = new Vector.<ConsortionSkillItenBtn>(2);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         var i:int = 0;
         if(this._open)
         {
            for(i = 0; i < this._cells.length; i++)
            {
               if(Boolean(this._cells[i]))
               {
                  this._cells[i].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               }
               if(Boolean(this._btns[i]))
               {
                  this._btns[i].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               }
            }
         }
      }
      
      public function set data(value:Vector.<ConsortionSkillInfo>) : void
      {
         var cell:ConsortionSkillCell = null;
         var btn:ConsortionSkillItenBtn = null;
         for(var i:int = 0; i < value.length; i++)
         {
            cell = new ConsortionSkillCell();
            cell.tipData = value[i];
            cell.contentRect(54,54);
            addChild(cell);
            PositionUtils.setPos(cell,"consortion.killItem.cellPos" + i);
            btn = new ConsortionSkillItenBtn();
            addChild(btn);
            PositionUtils.setPos(btn,"consortion.killItem.btnPos" + i);
            if(value[i].type == 1)
            {
               btn.setValue(LanguageMgr.GetTranslation("ddt.consortion.skillItem.oneDay"),value[i].riches + LanguageMgr.GetTranslation("consortia.Money"));
            }
            else if(this._isMetal)
            {
               btn.setValue(LanguageMgr.GetTranslation("ddt.consortion.skillItem.oneDay"),value[i].metal + LanguageMgr.GetTranslation("ddtMoney"));
            }
            else
            {
               btn.setValue(LanguageMgr.GetTranslation("ddt.consortion.skillItem.oneDay"),value[i].riches + LanguageMgr.GetTranslation("ddt.consortion.skillCell.btnPersonal.rich"));
            }
            cell.addEventListener(MouseEvent.CLICK,this.__clickHandler);
            btn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
            this._cells[i] = cell;
            this._btns[i] = btn;
         }
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(event.currentTarget is ConsortionSkillCell)
         {
            this._currentInfo = (event.currentTarget as ConsortionSkillCell).info;
         }
         else
         {
            this._currentInfo = this._cells[this._btns.indexOf(event.currentTarget as ConsortionSkillItenBtn)].info;
         }
         if(this._currentInfo.type == ConsortionModel.CONSORTION_SKILL && PlayerManager.Instance.Self.DutyLevel > 2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.SkillFrame.info"));
            return;
         }
         if(!this._open)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.open"));
            return;
         }
         var frame:ConsortionOpenSkillFrame = ComponentFactory.Instance.creatComponentByStylename("consortionOpenSkillFrame");
         frame.isMetal = this._isMetal;
         frame.info = this._currentInfo;
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __confirmResponseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendConsortionSkill(false,this._currentInfo.id,0);
         }
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponseHandler);
         frame.dispose();
         frame = null;
      }
      
      override public function get height() : Number
      {
         return this._bg1.height;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         for(var i:int = 0; i < 2; i++)
         {
            this._cells[i] = null;
            this._btns[i] = null;
         }
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._cellBG1 = null;
         this._cellBG2 = null;
         this._sign = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

