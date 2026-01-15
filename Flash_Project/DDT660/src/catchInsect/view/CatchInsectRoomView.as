package catchInsect.view
{
   import baglocked.BaglockedManager;
   import catchInsect.CatchInsectMananger;
   import catchInsect.componets.RoomMenuView;
   import catchInsect.controller.CatchInsectRoomController;
   import catchInsect.loader.LoaderCatchInsectUIModule;
   import catchInsect.model.CatchInsectRoomModel;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatView;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import store.HelpFrame;
   
   public class CatchInsectRoomView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZEII:Array = [1738,1300];
      
      private var _contoller:CatchInsectRoomController;
      
      private var _model:CatchInsectRoomModel;
      
      private var _sceneScene:SceneScene;
      
      private var _sceneMap:CatchInsectScneneMap;
      
      private var _chatFrame:ChatView;
      
      private var _roomMenuView:RoomMenuView;
      
      private var _sceneInfoViewBg:Bitmap;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _ballCountTxt:FilterFrameText;
      
      private var _netCountTxt:FilterFrameText;
      
      private var _buyBallBtn:SimpleBitmapButton;
      
      private var _buyNetBtn:SimpleBitmapButton;
      
      private var _useCakeBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _timer:Timer;
      
      public function CatchInsectRoomView(controller:CatchInsectRoomController, model:CatchInsectRoomModel)
      {
         super();
         this._contoller = controller;
         this._model = model;
         this.initialize();
         SocketManager.Instance.out.updateInsectInfo();
      }
      
      public function show() : void
      {
         this._contoller.addChild(this);
      }
      
      private function initialize() : void
      {
         SoundManager.instance.playMusic("12028");
         this._sceneScene = new SceneScene();
         ChatManager.Instance.state = ChatManager.CHAT_CATCH_INSECT;
         this._chatFrame = ChatManager.Instance.view;
         this._chatFrame.output.isLock = true;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._sceneInfoViewBg = ComponentFactory.Instance.creatBitmap("catchInsect.room.infoView");
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.scene.infoTxt");
         this._ballCountTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.scene.infoTxt");
         PositionUtils.setPos(this._ballCountTxt,"catchInsect.ballCountTxtPos");
         this._netCountTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.scene.infoTxt");
         PositionUtils.setPos(this._netCountTxt,"catchInsect.netCountTxtPos");
         this._buyBallBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.room.buyBallBtn");
         this._buyNetBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.room.buyNetBtn");
         this._useCakeBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.room.useCakeBtn");
         this._useCakeBtn.tipData = LanguageMgr.GetTranslation("catchInsect.uangAppear");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.HelpButton");
         PositionUtils.setPos(this._helpBtn,"catchInsect.HelpButtonPos");
         this._scoreTxt.text = CatchInsectMananger.instance.model.score.toString();
         this._ballCountTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(10615).toString();
         this._netCountTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(10616).toString();
         addChild(this._sceneInfoViewBg);
         addChild(this._scoreTxt);
         addChild(this._buyBallBtn);
         addChild(this._buyNetBtn);
         addChild(this._useCakeBtn);
         addChild(this._ballCountTxt);
         addChild(this._netCountTxt);
         addChild(this._helpBtn);
         this._roomMenuView = ComponentFactory.Instance.creat("catchInsect.room.menuView");
         addChild(this._roomMenuView);
         this._roomMenuView.addEventListener(Event.CLOSE,this._leaveRoom);
         this.setMap();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._buyBallBtn.addEventListener(MouseEvent.CLICK,this.__buyBallBtnClick);
         this._buyNetBtn.addEventListener(MouseEvent.CLICK,this.__buyNetBtnClick);
         this._useCakeBtn.addEventListener(MouseEvent.CLICK,this.__useCakeBtnClick);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         CatchInsectMananger.instance.addEventListener(CatchInsectMananger.UPDATE_INFO,this.__updateScore);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      protected function __helpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("catchInsect.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("catchInsect.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.changeSubmitButtonX(50);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.ringstation.helpTitle");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __useCakeBtnClick(event:MouseEvent) : void
      {
         var _quick:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.getItemByTemplateId(EquipType.INSECT_CAKE);
         if(Boolean(info))
         {
            SocketManager.Instance.out.sendUseCard(info.BagType,info.Place,[info.TemplateID],info.PayType);
            SocketManager.Instance.out.requestCakeStatus();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("catchInsect.noCake"));
            _quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quick.itemID = EquipType.INSECT_CAKE;
            LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function __updateScore(event:Event) : void
      {
         var total:int = CatchInsectMananger.instance.model.score;
         var avaible:int = CatchInsectMananger.instance.model.avaibleScore;
         this._scoreTxt.text = avaible.toString();
      }
      
      private function removeEvent() : void
      {
         this._buyBallBtn.removeEventListener(MouseEvent.CLICK,this.__buyBallBtnClick);
         this._buyNetBtn.removeEventListener(MouseEvent.CLICK,this.__buyNetBtnClick);
         this._useCakeBtn.removeEventListener(MouseEvent.CLICK,this.__useCakeBtnClick);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         CatchInsectMananger.instance.removeEventListener(CatchInsectMananger.UPDATE_INFO,this.__updateScore);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      protected function __updateGoods(evt:BagEvent) : void
      {
         this._ballCountTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(10615).toString();
         this._netCountTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(10616).toString();
      }
      
      protected function __buyNetBtnClick(event:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = 10616;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __buyBallBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = 10615;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function setViewAgain() : void
      {
         SoundManager.instance.playMusic("12028");
         ChatManager.Instance.state = ChatManager.CHAT_CATCH_INSECT;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = true;
         this._chatFrame.output.isLock = true;
         this._sceneMap.enterIng = false;
         SocketManager.Instance.out.updateInsectInfo();
      }
      
      public function setMap(localPos:Point = null) : void
      {
         CatchInsectMananger.isFrameChristmas = true;
         this.clearMap();
         var mapRes:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(LoaderCatchInsectUIModule.Instance.getMapRes()) as Class)() as MovieClip;
         var entity:Sprite = mapRes.getChildByName("articleLayer") as Sprite;
         var sky:Sprite = mapRes.getChildByName("NPCMouse") as Sprite;
         var mesh:Sprite = mapRes.getChildByName("mesh") as Sprite;
         var bg:Sprite = mapRes.getChildByName("bg") as Sprite;
         var bgSize:Sprite = mapRes.getChildByName("bgSize") as Sprite;
         var decoration:Sprite = mapRes.getChildByName("decoration") as Sprite;
         if(Boolean(bgSize))
         {
            MAP_SIZEII[0] = bgSize.width;
            MAP_SIZEII[1] = bgSize.height;
         }
         else
         {
            MAP_SIZEII[0] = bg.width;
            MAP_SIZEII[1] = bg.height;
         }
         this._sceneScene.setHitTester(new PathMapHitTester(mesh));
         if(!this._sceneMap)
         {
            this._sceneMap = new CatchInsectScneneMap(this._model,this._sceneScene,this._model.getPlayers(),this._model.getObjects(),bg,mesh,entity,sky,decoration);
            addChildAt(this._sceneMap,0);
         }
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(Boolean(localPos))
         {
            this._sceneMap.sceneMapVO.defaultPos = localPos;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var sceneMapVO:SceneMapVO = new SceneMapVO();
         sceneMapVO.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
         sceneMapVO.mapW = MAP_SIZEII[0];
         sceneMapVO.mapH = MAP_SIZEII[1];
         sceneMapVO.defaultPos = ComponentFactory.Instance.creatCustomObject("catchInsect.room.sceneMapVOPosII");
         return sceneMapVO;
      }
      
      public function movePlayer(id:int, p:Array) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.movePlayer(id,p);
         }
      }
      
      public function updatePlayerStauts(id:int, status:int, point:Point = null) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.updatePlayersStauts(id,status,point);
         }
      }
      
      public function updateSelfStatus(value:int) : void
      {
         this._sceneMap.updateSelfStatus(value);
      }
      
      private function _leaveRoom(e:Event) : void
      {
         StateManager.setState(StateType.MAIN);
         this._contoller.dispose();
      }
      
      private function clearMap() : void
      {
         if(Boolean(this._sceneMap))
         {
            if(Boolean(this._sceneMap.parent))
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearMap();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._roomMenuView = null;
         this._sceneScene = null;
         this._sceneMap = null;
         this._chatFrame = null;
         this._sceneInfoViewBg = null;
         this._scoreTxt = null;
         this._ballCountTxt = null;
         this._netCountTxt = null;
         this._buyBallBtn = null;
         this._buyNetBtn = null;
         this._useCakeBtn = null;
         this._helpBtn = null;
      }
   }
}

