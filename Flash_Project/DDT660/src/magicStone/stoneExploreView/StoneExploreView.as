package magicStone.stoneExploreView
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import magicStone.MagicStoneManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class StoneExploreView extends Frame
   {
      
      private static var index:int = 0;
      
      private var _BG:ScaleBitmapImage;
      
      private var _ordinaryBG:Bitmap;
      
      private var _eliteBG:Bitmap;
      
      private var _startOrdinaryBtn:BaseButton;
      
      private var _startEliteBtn:BaseButton;
      
      private var _ordinaryTxt:FilterFrameText;
      
      private var _eliteTxt:FilterFrameText;
      
      private var _helpTxt:FilterFrameText;
      
      private var _paopaoOrdinaryBg:Bitmap;
      
      private var _paopaoOrdinaryTxt:FilterFrameText;
      
      private var _scOrdinaryBtn:SelectedCheckButton;
      
      private var _paopaoEliteBg:Bitmap;
      
      private var _paopaoEliteTxt:FilterFrameText;
      
      private var _scEliteBtn:SelectedCheckButton;
      
      private var _clickDate:Number = 0;
      
      private var _selfInfo:SelfInfo;
      
      private var _quick:QuickBuyFrame;
      
      public function StoneExploreView()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         _titleText = LanguageMgr.GetTranslation("StoneExploreView.titleText");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("StoneExploreView.bg1");
         addToContent(this._BG);
         this._ordinaryBG = ComponentFactory.Instance.creatBitmap("magicStone.stoneExplore.ordinaryBG");
         addToContent(this._ordinaryBG);
         this._eliteBG = ComponentFactory.Instance.creatBitmap("magicStone.stoneExplore.eliteBG");
         addToContent(this._eliteBG);
         this._startOrdinaryBtn = ComponentFactory.Instance.creat("magicStone.stoneExplore.startOrdinaryBtn");
         addToContent(this._startOrdinaryBtn);
         this._startEliteBtn = ComponentFactory.Instance.creat("magicStone.stoneExplore.startEliteBtn");
         addToContent(this._startEliteBtn);
         this._ordinaryTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.stoneExplore.ordinaryTxt");
         this._ordinaryTxt.text = LanguageMgr.GetTranslation("magicStone.stoneExplore.ordinaryTxt");
         addToContent(this._ordinaryTxt);
         this._eliteTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.stoneExplore.eliteTxt");
         this._eliteTxt.text = LanguageMgr.GetTranslation("magicStone.stoneExplore.eliteTxt");
         addToContent(this._eliteTxt);
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.stoneExplore.helpTxt");
         this._helpTxt.text = LanguageMgr.GetTranslation("magicStone.stoneExplore.helpTxt");
         addToContent(this._helpTxt);
         this._paopaoOrdinaryBg = ComponentFactory.Instance.creatBitmap("magicStone.stoneExplore.paopao");
         PositionUtils.setPos(this._paopaoOrdinaryBg,"magicStone.stoneExplore.paopaoOrdinary");
         addToContent(this._paopaoOrdinaryBg);
         this._paopaoOrdinaryTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.stoneExplore.paopaoOrdinaryTxt");
         this._paopaoOrdinaryTxt.text = MagicStoneManager.instance.model.normalFightNum.toString();
         addToContent(this._paopaoOrdinaryTxt);
         this._scOrdinaryBtn = ComponentFactory.Instance.creat("magicStone.stoneExplore.scOrdinaryBtn");
         this._scOrdinaryBtn.selected = true;
         this._scOrdinaryBtn.text = LanguageMgr.GetTranslation("magicStone.stoneExplore.scOrdinaryBtnLG");
         addToContent(this._scOrdinaryBtn);
         this._paopaoEliteBg = ComponentFactory.Instance.creatBitmap("magicStone.stoneExplore.paopao");
         PositionUtils.setPos(this._paopaoEliteBg,"magicStone.stoneExplore.paopaoElite");
         addToContent(this._paopaoEliteBg);
         this._paopaoEliteTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.stoneExplore.paopaoEliteTxt");
         this._paopaoEliteTxt.text = MagicStoneManager.instance.model.hardFightNum.toString();
         addToContent(this._paopaoEliteTxt);
         this._scEliteBtn = ComponentFactory.Instance.creat("magicStone.stoneExplore.scEliteBtn");
         this._scEliteBtn.selected = true;
         this._scEliteBtn.text = LanguageMgr.GetTranslation("magicStone.stoneExplore.scOrdinaryBtnLG");
         addToContent(this._scEliteBtn);
         this.setBtnEnable();
      }
      
      private function addEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._startOrdinaryBtn.addEventListener(MouseEvent.CLICK,this.__startOrdinaryBtnClick);
         this._startEliteBtn.addEventListener(MouseEvent.CLICK,this.__startEliteBtnClick);
         this._scOrdinaryBtn.addEventListener(MouseEvent.CLICK,this.__scOrdinaryCheckBoxClick);
         this._scEliteBtn.addEventListener(MouseEvent.CLICK,this.__scEliteCheckBoxClick);
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._startOrdinaryBtn.removeEventListener(MouseEvent.CLICK,this.__startOrdinaryBtnClick);
         this._startEliteBtn.removeEventListener(MouseEvent.CLICK,this.__startEliteBtnClick);
         this._scOrdinaryBtn.removeEventListener(MouseEvent.CLICK,this.__scOrdinaryCheckBoxClick);
         this._scEliteBtn.removeEventListener(MouseEvent.CLICK,this.__scEliteCheckBoxClick);
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __gameStart(pEvent:CrazyTankSocketEvent) : void
      {
         if(index == 0)
         {
            GameInSocketOut.sendGameRoomSetUp(StoneExploreModel.OrdinaryMissionID,RoomInfo.STONEEXPLORE_ROOM,false,"","",3,0,0,false,StoneExploreModel.OrdinaryMissionID);
            GameInSocketOut.sendGameStart();
         }
         else
         {
            GameInSocketOut.sendGameRoomSetUp(StoneExploreModel.EliteMissionID,RoomInfo.STONEEXPLORE_ROOM,false,"","",3,0,0,false,StoneExploreModel.EliteMissionID);
            GameInSocketOut.sendGameStart();
         }
      }
      
      private function __startOrdinaryBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(new Date().time - this._clickDate > 1000)
         {
            if(this._scOrdinaryBtn.selected)
            {
               if(this.checkBagStone())
               {
                  if(this.checkCanStartGame() && MagicStoneManager.instance.model.normalFightNum > 0)
                  {
                     index = 0;
                     GameInSocketOut.sendCreateRoom(StoneExploreModel.OrdinaryMissionID.toString(),RoomInfo.STONEEXPLORE_ROOM,3,"",this._scOrdinaryBtn.selected);
                  }
               }
               else
               {
                  if(PlayerManager.Instance.Self.bagLocked)
                  {
                     BaglockedManager.Instance.show();
                     return;
                  }
                  this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                  this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                  this._quick.itemID = 201581;
                  this._quick.setIsStoneExploreView(true);
                  LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               }
            }
            else if(this.checkCanStartGame() && MagicStoneManager.instance.model.normalFightNum > 0)
            {
               index = 0;
               GameInSocketOut.sendCreateRoom(StoneExploreModel.OrdinaryMissionID.toString(),RoomInfo.STONEEXPLORE_ROOM,3,"",this._scOrdinaryBtn.selected);
            }
         }
      }
      
      private function __startEliteBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(new Date().time - this._clickDate > 1000)
         {
            if(this._scEliteBtn.selected)
            {
               if(this.checkBagStone())
               {
                  if(this.checkCanStartGame() && MagicStoneManager.instance.model.hardFightNum > 0)
                  {
                     index = 1;
                     GameInSocketOut.sendCreateRoom(StoneExploreModel.EliteMissionID.toString(),RoomInfo.STONEEXPLORE_ROOM,3,"",this._scEliteBtn.selected);
                  }
               }
               else
               {
                  if(PlayerManager.Instance.Self.bagLocked)
                  {
                     BaglockedManager.Instance.show();
                     return;
                  }
                  this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                  this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                  this._quick.itemID = 201581;
                  this._quick.setIsStoneExploreView(true);
                  LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               }
            }
            else if(this.checkCanStartGame() && MagicStoneManager.instance.model.hardFightNum > 0)
            {
               index = 1;
               GameInSocketOut.sendCreateRoom(StoneExploreModel.EliteMissionID.toString(),RoomInfo.STONEEXPLORE_ROOM,3,"",this._scEliteBtn.selected);
            }
         }
      }
      
      private function checkBagStone() : Boolean
      {
         var bagInfo:BagInfo = this._selfInfo.getBag(BagInfo.PROPBAG);
         var conut:int = bagInfo.getItemCountByTemplateId(201581);
         if(conut >= ServerConfigManager.instance.magicStoneCostItemNum)
         {
            return true;
         }
         return false;
      }
      
      private function setBtnEnable() : void
      {
         if(MagicStoneManager.instance.model.hardFightNum <= 0)
         {
            this._startEliteBtn.enable = this._startEliteBtn.mouseChildren = this._startEliteBtn.mouseEnabled = false;
         }
         if(MagicStoneManager.instance.model.normalFightNum <= 0)
         {
            this._startOrdinaryBtn.enable = this._startOrdinaryBtn.mouseChildren = this._startOrdinaryBtn.mouseEnabled = false;
         }
      }
      
      private function __scOrdinaryCheckBoxClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __scEliteCheckBoxClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function checkCanStartGame() : Boolean
      {
         var result:Boolean = true;
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            result = false;
         }
         return result;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._quick))
         {
            ObjectUtils.disposeObject(this._quick);
         }
         this._quick = null;
      }
   }
}

