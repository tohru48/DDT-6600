package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import horse.HorseManager;
   import horse.data.HorseSkillExpVo;
   import horse.data.HorseSkillGetVo;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class HorseSkillFrameCell extends Sprite implements Disposeable
   {
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _upBtn:SimpleBitmapButton;
      
      private var _fullTxt:FilterFrameText;
      
      private var _skillCell:HorseSkillCell;
      
      private var _dataList:Vector.<HorseSkillGetVo>;
      
      private var _isGet:Boolean = false;
      
      private var _curShowSkill:HorseSkillExpVo;
      
      private var _index:int = -1;
      
      public function HorseSkillFrameCell(data:Vector.<HorseSkillGetVo>)
      {
         super();
         this._dataList = data;
         this.confirmCurShowSkillId();
         this.initView();
         this.initEvent();
         this.refreshView();
      }
      
      private function confirmCurShowSkillId() : void
      {
         var tmp:HorseSkillExpVo = null;
         var len:int = 0;
         var i:int = 0;
         var tmpGetList:Vector.<HorseSkillExpVo> = HorseManager.instance.curHasSkillList;
         for each(tmp in tmpGetList)
         {
            len = int(this._dataList.length);
            for(i = 0; i < len; i++)
            {
               if(tmp.skillId == this._dataList[i].SkillID)
               {
                  this._isGet = true;
                  this._index = i;
                  this._curShowSkill = tmp;
                  break;
               }
            }
         }
         if(!this._curShowSkill)
         {
            this._isGet = false;
            this._index = -1;
            this._curShowSkill = new HorseSkillExpVo();
            this._curShowSkill.skillId = this._dataList[0].SkillID;
         }
      }
      
      private function initView() : void
      {
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("horse.skillFrame.cell.getBtn");
         this._upBtn = ComponentFactory.Instance.creatComponentByStylename("horse.skillFrame.cell.upBtn");
         this._fullTxt = ComponentFactory.Instance.creatComponentByStylename("horse.skillFrame.cell.fullTxt");
         this._fullTxt.text = LanguageMgr.GetTranslation("horse.skillFrame.fullTxt");
         addChild(this._getBtn);
         addChild(this._upBtn);
         addChild(this._fullTxt);
      }
      
      private function refreshView() : void
      {
         if(Boolean(this._skillCell))
         {
            this._skillCell.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
            this._skillCell.dispose();
         }
         this._skillCell = new HorseSkillCell(this._curShowSkill.skillId);
         this._skillCell.x = 5;
         this._skillCell.addEventListener(MouseEvent.CLICK,this.__mouseClick,false,0,true);
         addChild(this._skillCell);
         if(this._isGet)
         {
            this._getBtn.visible = false;
            if(this._index == this._dataList.length - 1)
            {
               this._upBtn.visible = false;
               this._fullTxt.visible = true;
            }
            else
            {
               this._upBtn.visible = true;
               this._fullTxt.visible = false;
            }
            this._skillCell.filters = null;
            this._skillCell.buttonMode = true;
         }
         else
         {
            this._getBtn.visible = true;
            this._upBtn.visible = false;
            this._fullTxt.visible = false;
            this._skillCell.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function __mouseClick(evt:MouseEvent) : void
      {
         if(!this._isGet)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(HorseManager.instance.isSkillHasEquip(this._curShowSkill.skillId))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.skillCannotEquipSame"));
            return;
         }
         var tmpPlace:int = HorseManager.instance.takeUpSkillPlace;
         if(tmpPlace == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.skillEquipMax"));
            return;
         }
         SocketManager.Instance.out.sendHorseTakeUpDownSkill(this._curShowSkill.skillId,tmpPlace);
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_5))
         {
            SocketManager.Instance.out.syncWeakStep(Step.HORSE_GUIDE_5);
            NewHandContainer.Instance.clearArrowByID(ArrowType.HORSE_GUIDE);
         }
      }
      
      private function initEvent() : void
      {
         this._upBtn.addEventListener(MouseEvent.CLICK,this.upClickHandler,false,0,true);
         this._getBtn.addEventListener(MouseEvent.CLICK,this.getClickHandler,false,0,true);
         HorseManager.instance.addEventListener(HorseManager.UP_SKILL,this.upSkillSucHandler);
      }
      
      private function upSkillSucHandler(event:Event) : void
      {
         this.confirmCurShowSkillId();
         this.refreshView();
      }
      
      private function upClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:HorseSkillUpFrame = ComponentFactory.Instance.creatComponentByStylename("HorseSkillUpFrame");
         frame.show(this._index,this._curShowSkill,this._dataList);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function getClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var skillId:int = this._curShowSkill.skillId;
         var level:int = HorseManager.instance.getLevelBySkillId(skillId);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.skillGetLevelPrompt",int(level / 10) + 1,level % 10));
      }
      
      private function removeEvent() : void
      {
         this._upBtn.removeEventListener(MouseEvent.CLICK,this.upClickHandler);
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.getClickHandler);
         HorseManager.instance.removeEventListener(HorseManager.UP_SKILL,this.upSkillSucHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._getBtn = null;
         this._upBtn = null;
         this._fullTxt = null;
         this._skillCell = null;
         this._dataList = null;
         this._curShowSkill = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

