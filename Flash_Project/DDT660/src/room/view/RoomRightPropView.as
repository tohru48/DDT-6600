package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import horse.HorseManager;
   import horse.data.HorseSkillExpVo;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomRightPropView extends Sprite implements Disposeable
   {
      
      public static const UPCELLS_NUMBER:int = 3;
      
      protected var _bg:MovieClip;
      
      protected var _secBg:MutipleImage;
      
      protected var _upCells:Vector.<RoomPropCell>;
      
      protected var _upCellsContainer:HBox;
      
      protected var _downCellsContainer:SimpleTileList;
      
      protected var _downCellsSprite:Sprite;
      
      protected var _downCellsScrollPanel:ScrollPanel;
      
      protected var _roomIdTxt:FilterFrameText;
      
      protected var _chanelNameTxt:FilterFrameText;
      
      protected var _goldInfoTxt:FilterFrameText;
      
      protected var _roomNameTxt:FilterFrameText;
      
      protected var _upCellsStripTip:StripTip;
      
      protected var _downCellsStripTip:StripTip;
      
      public function RoomRightPropView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      protected function initView() : void
      {
         var tmpHasSkillList:Vector.<HorseSkillExpVo> = null;
         var j:int = 0;
         var place:String = null;
         var roomInfo:RoomInfo = null;
         var cell:RoomPropCell = null;
         var cell1:RoomPropCell = null;
         this._bg = ClassUtils.CreatInstance("asset.background.room.left") as MovieClip;
         addChild(this._bg);
         this._secBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.roomRightPropView.secbg");
         addChild(this._secBg);
         this._upCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upCellsContainer");
         addChild(this._upCellsContainer);
         this._downCellsContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downCellsContainer",[3]);
         this._downCellsScrollPanel = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.downCellsScrollPanel");
         addChild(this._downCellsScrollPanel);
         this._upCells = new Vector.<RoomPropCell>();
         for(var i:int = 0; i < UPCELLS_NUMBER; i++)
         {
            cell = new RoomPropCell(true,i);
            this._upCellsContainer.addChild(cell);
            this._upCells.push(cell);
         }
         this._downCellsSprite = new Sprite();
         tmpHasSkillList = HorseManager.instance.curHasSkillList;
         var tmpLen:int = int(tmpHasSkillList.length);
         for(j = 0; j < tmpLen; j++)
         {
            cell1 = new RoomPropCell(false,i);
            cell1.x = 2 + j % 3 * 54;
            cell1.y = 2 + int(j / 3) * 49;
            this._downCellsSprite.addChild(cell1);
            cell1.skillId = tmpHasSkillList[j].skillId;
         }
         this._downCellsScrollPanel.setView(this._downCellsSprite);
         this._chanelNameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.ChanelNameText");
         addChild(this._chanelNameTxt);
         this._roomNameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.roomNameText");
         addChild(this._roomNameTxt);
         var tmpUseSkillList:DictionaryData = HorseManager.instance.curUseSkillList;
         for(place in tmpUseSkillList)
         {
            this._upCells[int(place) - 1].skillId = tmpUseSkillList[place];
         }
         roomInfo = RoomManager.Instance.current;
         if(Boolean(roomInfo))
         {
            this._roomIdTxt = ComponentFactory.Instance.creatComponentByStylename("room.roomID.text");
            this._roomIdTxt.text = RoomManager.Instance.current.ID.toString();
            addChild(this._roomIdTxt);
            if(this._roomNameTxt != null)
            {
               this._roomNameTxt.text = RoomManager.Instance.current.Name == null ? "" : RoomManager.Instance.current.Name;
            }
         }
         this._chanelNameTxt.text = ServerManager.Instance.current.Name;
         this.creatTipShapeTip();
      }
      
      protected function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         HorseManager.instance.addEventListener(HorseManager.TAKE_UP_DOWN_SKILL,this.updateSkillStatus);
         if(Boolean(RoomManager.Instance.current))
         {
            RoomManager.Instance.current.addEventListener(RoomEvent.ROOM_NAME_CHANGED,this._roomNameChanged);
         }
      }
      
      protected function removeEvents() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         HorseManager.instance.removeEventListener(HorseManager.TAKE_UP_DOWN_SKILL,this.updateSkillStatus);
         if(Boolean(RoomManager.Instance.current))
         {
            RoomManager.Instance.current.removeEventListener(RoomEvent.ROOM_NAME_CHANGED,this._roomNameChanged);
         }
      }
      
      protected function _roomNameChanged(evt:RoomEvent) : void
      {
         this._roomNameTxt.text = RoomManager.Instance.current.Name;
      }
      
      protected function creatTipShapeTip() : void
      {
         this._upCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.upRightPropTip");
         this._downCellsStripTip = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.downRightPropTip");
         this._upCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.uppropTip");
         this._downCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.downpropTip");
         addChild(this._upCellsStripTip);
         addChild(this._downCellsStripTip);
      }
      
      protected function __updateGold(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties[PlayerInfo.GOLD]))
         {
         }
      }
      
      protected function updateSkillStatus(event:Event) : void
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
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(Boolean(this._secBg))
         {
            ObjectUtils.disposeObject(this._secBg);
         }
         this._secBg = null;
         if(Boolean(this._roomIdTxt))
         {
            this._roomIdTxt.dispose();
            this._roomIdTxt = null;
         }
         this._upCells = null;
         this._upCellsContainer.dispose();
         this._upCellsContainer = null;
         this._downCellsContainer.dispose();
         this._downCellsContainer = null;
         this._chanelNameTxt.dispose();
         this._chanelNameTxt = null;
         if(Boolean(this._roomNameTxt))
         {
            ObjectUtils.disposeObject(this._roomNameTxt);
         }
         this._roomNameTxt = null;
         if(Boolean(this._upCellsStripTip))
         {
            ObjectUtils.disposeObject(this._upCellsStripTip);
         }
         this._upCellsStripTip = null;
         if(Boolean(this._downCellsStripTip))
         {
            ObjectUtils.disposeObject(this._downCellsStripTip);
         }
         this._downCellsStripTip = null;
         ObjectUtils.disposeAllChildren(this._downCellsSprite);
         ObjectUtils.disposeObject(this._downCellsSprite);
         this._downCellsSprite = null;
         ObjectUtils.disposeObject(this._downCellsScrollPanel);
         this._downCellsScrollPanel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

