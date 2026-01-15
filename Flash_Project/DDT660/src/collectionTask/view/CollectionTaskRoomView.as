package collectionTask.view
{
   import church.vo.SceneMapVO;
   import collectionTask.CollectionTaskManager;
   import collectionTask.model.CollectionTaskModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class CollectionTaskRoomView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZE:Array = [1200,1077];
      
      private var _sceneScene:SceneScene;
      
      private var _chatFrame:Sprite;
      
      private var _sceneMap:CollectionTaskSceneMap;
      
      private var _model:CollectionTaskModel;
      
      private var _menuView:CollectionTaskMenuView;
      
      private var _exitMenuView:CollectionTaskExitMenuView;
      
      private var _taskProgressView:TaskProgressView;
      
      private var _progress:ProgressSprite;
      
      private var _taskCompleteMc:MovieClip;
      
      private var _backBtnMc:MovieClip;
      
      public function CollectionTaskRoomView(model:CollectionTaskModel)
      {
         super();
         this._model = model;
         this.initView();
      }
      
      private function initView() : void
      {
         this._sceneScene = new SceneScene();
         ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         this.setMap();
         this._menuView = ComponentFactory.Instance.creatCustomObject("collectionTask.CollectionTaskMenuView",[this._model]);
         addChild(this._menuView);
         this._exitMenuView = ComponentFactory.Instance.creatCustomObject("collectionTask.CollectionTaskExitMenuView");
         addChild(this._exitMenuView);
         this._taskProgressView = ComponentFactory.Instance.creatCustomObject("collectionTask.taskProgressView");
         addChild(this._taskProgressView);
      }
      
      public function setMap(localPos:Point = null) : void
      {
         this.clearMap();
         var mapRes:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this.getMapRes()) as Class)() as MovieClip;
         var article:Sprite = mapRes.getChildByName("articleLayer") as Sprite;
         var entity:Sprite = mapRes.getChildByName("entity") as Sprite;
         var sky:Sprite = mapRes.getChildByName("sky") as Sprite;
         var mesh:Sprite = mapRes.getChildByName("mesh") as Sprite;
         var bg:Sprite = mapRes.getChildByName("bg") as Sprite;
         MAP_SIZE[0] = bg.width;
         MAP_SIZE[1] = bg.height;
         this._sceneScene.setHitTester(new PathMapHitTester(mesh));
         if(!this._sceneMap)
         {
            this._sceneMap = new CollectionTaskSceneMap(this._model,this._sceneScene,this._model.getPlayers(),bg,mesh,entity,sky,article);
            addChildAt(this._sceneMap,0);
         }
         this._sceneMap.setPlayProgressFunc(this.addProgressMc);
         this._sceneMap.setStopProgressFunc(this.stopProgressMc);
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(Boolean(localPos))
         {
            this._sceneMap.sceneMapVO.defaultPos = localPos;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
      }
      
      public function refreshProgress() : void
      {
         this._taskProgressView.refreshView();
         if(CollectionTaskManager.Instance.questInfo.isCompleted)
         {
            this._taskCompleteMc = ComponentFactory.Instance.creat("collectionTask.tashComplete.MC");
            addChild(this._taskCompleteMc);
            this._taskCompleteMc.x = 350;
            this._taskCompleteMc.y = 280;
            this._taskCompleteMc.addEventListener(Event.ENTER_FRAME,this.__taskCompleteHandler);
            this._backBtnMc = ComponentFactory.Instance.creat("collectionTask.backBtn.MC");
            this._backBtnMc.scaleY = 1.1;
            this._backBtnMc.x = this._exitMenuView.x;
            this._backBtnMc.y = this._exitMenuView.y;
            addChild(this._backBtnMc);
         }
      }
      
      protected function __taskCompleteHandler(event:Event) : void
      {
         if(this._taskCompleteMc.currentFrame >= 71)
         {
            this._taskCompleteMc.removeEventListener(Event.ENTER_FRAME,this.__taskCompleteHandler);
            removeChild(this._taskCompleteMc);
            this._taskCompleteMc.stop();
            this._taskCompleteMc = null;
         }
      }
      
      public function addProgressMc() : void
      {
         if(!this.checkCanCollect())
         {
            return;
         }
         this._progress = new ProgressSprite(SocketManager.Instance.out.sendCollectionComplete);
         this._progress.x = 430;
         this._progress.y = 440;
         addChild(this._progress);
      }
      
      private function checkCanCollect() : Boolean
      {
         var condition:QuestCondition = null;
         var info:QuestInfo = CollectionTaskManager.Instance.questInfo;
         for(var i:int = 0; i < info._conditions.length; i++)
         {
            condition = info._conditions[i];
            if(condition.param != CollectionTaskManager.Instance.collectedId)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("collectionTask.cannotCollectTip",ItemManager.Instance.getTemplateById(condition.param).Name));
               return false;
            }
            if(info.progress[i] > 0 && !CollectionTaskManager.Instance.isCollecting)
            {
               return true;
            }
         }
         return false;
      }
      
      public function stopProgressMc() : void
      {
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var sceneMapVO:SceneMapVO = new SceneMapVO();
         sceneMapVO.mapName = LanguageMgr.GetTranslation("collectionTask.scene");
         sceneMapVO.mapW = MAP_SIZE[0];
         sceneMapVO.mapH = MAP_SIZE[1];
         sceneMapVO.defaultPos = ComponentFactory.Instance.creatCustomObject("collectionTask.sceneMapVOPos");
         return sceneMapVO;
      }
      
      public function movePlayer(id:int, p:Array) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.movePlayer(id,p);
         }
      }
      
      public function getAllPlayersLength() : int
      {
         return this._sceneMap.characters.length;
      }
      
      public function addRobertPlayer(len:int) : void
      {
         if(Boolean(this._sceneMap))
         {
            this._sceneMap.addRobertPlayer(len);
         }
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
      
      public function getMapRes() : String
      {
         return "tank.collectionTask.Map";
      }
      
      public function dispose() : void
      {
         if(Boolean(this._backBtnMc))
         {
            removeChild(this._backBtnMc);
            this._backBtnMc = null;
         }
         if(Boolean(this._sceneScene))
         {
            this._sceneScene.dispose();
         }
         this._sceneScene = null;
         if(Boolean(this._sceneMap))
         {
            if(Boolean(this._sceneMap.parent))
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         if(Boolean(this._chatFrame.parent))
         {
            this._chatFrame.parent.removeChild(this._chatFrame);
         }
         this._chatFrame = null;
         ObjectUtils.disposeObject(this._menuView);
         this._menuView = null;
         ObjectUtils.disposeObject(this._exitMenuView);
         this._exitMenuView = null;
         ObjectUtils.disposeObject(this._taskProgressView);
         this._taskProgressView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

