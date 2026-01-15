package horse.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.HBox;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import horse.HorseManager;
   import road7th.data.DictionaryData;
   import room.view.RoomPropCell;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class HorseSkillFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _upCellsContainer:HBox;
      
      private var _upCells:Vector.<RoomPropCell>;
      
      private var _helpBtn:HorseSkillFrameHelpBtn;
      
      public function HorseSkillFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.guideHandler();
      }
      
      private function guideHandler() : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_5) && HorseManager.instance.curLevel >= 1)
         {
            NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE,0,new Point(55,-32),"asset.horse.skillEquipGuideTxt","horse.skillFrame.equipGuidePos",_container);
         }
      }
      
      private function initView() : void
      {
         var sprite:Sprite = null;
         var i:int = 0;
         var cell:HorseSkillFrameCell = null;
         var cell2:RoomPropCell = null;
         titleText = LanguageMgr.GetTranslation("horse.skillFrame.titleTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.horse.skillFrame.bg");
         addToContent(this._bg);
         sprite = new Sprite();
         var tmpData:Array = HorseManager.instance.horseSkillGetArray;
         var tmpLen:int = int(tmpData.length);
         for(i = 0; i < tmpLen; i++)
         {
            cell = new HorseSkillFrameCell(tmpData[i]);
            cell.x = i % 4 * 67;
            cell.y = int(i / 4) * 81;
            sprite.addChild(cell);
         }
         var scrollPanel:ScrollPanel = ComponentFactory.Instance.creatComponentByStylename("horse.skillFrame.skillCellList");
         scrollPanel.setView(sprite);
         addToContent(scrollPanel);
         this._upCellsContainer = ComponentFactory.Instance.creatComponentByStylename("horse.skillFrame.upCellsContainer");
         addToContent(this._upCellsContainer);
         this._upCells = new Vector.<RoomPropCell>();
         for(var j:int = 0; j < 3; j++)
         {
            cell2 = new RoomPropCell(true,j,true);
            this._upCellsContainer.addChild(cell2);
            this._upCells.push(cell2);
         }
         this.updateSkillStatus(null);
         this._helpBtn = new HorseSkillFrameHelpBtn();
         addToContent(this._helpBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         HorseManager.instance.addEventListener(HorseManager.TAKE_UP_DOWN_SKILL,this.updateSkillStatus);
      }
      
      private function updateSkillStatus(event:Event) : void
      {
         var tmpKey:String = null;
         var tmpUseSkillList:DictionaryData = HorseManager.instance.curUseSkillList;
         var tmplen:int = int(this._upCells.length);
         for(var i:int = 0; i < tmplen; i++)
         {
            tmpKey = (i + 1).toString();
            if(tmpUseSkillList.hasKey(tmpKey))
            {
               this._upCells[i].skillId = tmpUseSkillList[tmpKey];
            }
            else
            {
               this._upCells[i].skillId = 0;
            }
         }
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_6))
         {
            NewHandContainer.Instance.showArrow(ArrowType.HORSE_GUIDE,0,new Point(339,-45),"","",this);
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         HorseManager.instance.removeEventListener(HorseManager.TAKE_UP_DOWN_SKILL,this.updateSkillStatus);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._upCellsContainer = null;
         this._upCells = null;
         this._helpBtn = null;
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_6) && PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_5))
         {
            SocketManager.Instance.out.syncWeakStep(Step.HORSE_GUIDE_6);
            NewHandContainer.Instance.clearArrowByID(ArrowType.HORSE_GUIDE);
            HorseManager.instance.dispatchEvent(new Event(HorseManager.GUIDE_6_TO_7));
         }
      }
   }
}

