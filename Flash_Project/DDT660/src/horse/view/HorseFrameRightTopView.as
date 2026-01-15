package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import horse.HorseManager;
   import horse.data.HorseTemplateVo;
   import horse.horsePicCherish.HorsePicCherishFrame;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class HorseFrameRightTopView extends Sprite implements Disposeable
   {
      
      private var _addPropertyValueTxtList:Vector.<FilterFrameText>;
      
      private var _skillBtn:SimpleBitmapButton;
      
      private var _picBtn:SimpleBitmapButton;
      
      public function HorseFrameRightTopView()
      {
         super();
         this.initView();
         this.initEvent();
         this.refreshView();
         this.guideHandler();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var nameTxt:FilterFrameText = null;
         var valueTxt:FilterFrameText = null;
         this._addPropertyValueTxtList = new Vector.<FilterFrameText>();
         var nameStrList:Array = LanguageMgr.GetTranslation("horse.addPropertyNameStr").split(",");
         for(i = 0; i < 5; i++)
         {
            nameTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.addPorpertyNameTxt");
            nameTxt.text = nameStrList[i];
            nameTxt.y += i * 29;
            valueTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.addPorpertyValueTxt");
            valueTxt.text = "0";
            valueTxt.y += i * 29;
            this._addPropertyValueTxtList.push(valueTxt);
            addChild(nameTxt);
            addChild(valueTxt);
         }
         this._skillBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.skillBtn");
         this._picBtn = ComponentFactory.Instance.creatComponentByStylename("horse.frame.picBtn");
         addChild(this._skillBtn);
         addChild(this._picBtn);
      }
      
      private function initEvent() : void
      {
         this._skillBtn.addEventListener(MouseEvent.CLICK,this.skillClickHandler,false,0,true);
         this._picBtn.addEventListener(MouseEvent.CLICK,this.picClickHandler,false,0,true);
         HorseManager.instance.addEventListener(HorseManager.UP_HORSE_STEP_2,this.upHorseHandler);
         HorseManager.instance.addEventListener(HorseManager.PRE_NEXT_EFFECT,this.refreshNextView);
         HorseManager.instance.addEventListener(HorseManager.REFRESH_CUR_EFFECT,this.refreshView);
      }
      
      private function upHorseHandler(event:Event) : void
      {
         this.refreshView();
         this.guideHandler();
      }
      
      private function guideHandler() : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_4) && HorseManager.instance.curLevel >= 1)
         {
            NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE,0,new Point(530,154),"","",this);
         }
      }
      
      private function skillClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_4) && HorseManager.instance.curLevel >= 1)
         {
            SocketManager.Instance.out.syncWeakStep(Step.HORSE_GUIDE_4);
            NewHandContainer.Instance.clearArrowByID(ArrowType.HORSE_GUIDE);
         }
         var frame:HorseSkillFrame = ComponentFactory.Instance.creatComponentByStylename("HorseSkillFrame");
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function picClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:HorsePicCherishFrame = ComponentFactory.Instance.creatComponentByStylename("HorsePicCherishFrame");
         frame.index = 1;
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function refreshView(event:Event = null) : void
      {
         var tmp:HorseTemplateVo = HorseManager.instance.curHorseTemplateInfo;
         this._addPropertyValueTxtList[0].text = tmp.AddDamage.toString();
         this._addPropertyValueTxtList[1].text = tmp.AddGuard.toString();
         this._addPropertyValueTxtList[2].text = tmp.AddBlood.toString();
         this._addPropertyValueTxtList[3].text = tmp.MagicAttack.toString();
         this._addPropertyValueTxtList[4].text = tmp.MagicDefence.toString();
      }
      
      private function refreshNextView(event:Event = null) : void
      {
         var curLevel:int = HorseManager.instance.curLevel;
         var nextBigLevel:int = (int(curLevel / 10) + 1) * 10;
         var tmp:HorseTemplateVo = HorseManager.instance.getHorseTemplateInfoByLevel(nextBigLevel);
         if(!tmp)
         {
            return;
         }
         this._addPropertyValueTxtList[0].text = tmp.AddDamage.toString();
         this._addPropertyValueTxtList[1].text = tmp.AddGuard.toString();
         this._addPropertyValueTxtList[2].text = tmp.AddBlood.toString();
         this._addPropertyValueTxtList[3].text = tmp.MagicAttack.toString();
         this._addPropertyValueTxtList[4].text = tmp.MagicDefence.toString();
         this._addPropertyValueTxtList[0].textColor = 15216382;
         this._addPropertyValueTxtList[1].textColor = 15216382;
         this._addPropertyValueTxtList[2].textColor = 15216382;
         this._addPropertyValueTxtList[3].textColor = 15216382;
         this._addPropertyValueTxtList[4].textColor = 15216382;
      }
      
      private function removeEvent() : void
      {
         this._skillBtn.removeEventListener(MouseEvent.CLICK,this.skillClickHandler);
         this._picBtn.removeEventListener(MouseEvent.CLICK,this.picClickHandler);
         HorseManager.instance.removeEventListener(HorseManager.UP_HORSE_STEP_2,this.upHorseHandler);
         HorseManager.instance.removeEventListener(HorseManager.PRE_NEXT_EFFECT,this.refreshNextView);
         HorseManager.instance.removeEventListener(HorseManager.REFRESH_CUR_EFFECT,this.refreshView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._addPropertyValueTxtList = null;
         this._skillBtn = null;
         this._picBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

